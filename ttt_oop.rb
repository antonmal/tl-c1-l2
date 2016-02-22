require 'pry'
require 'colorize'

# Tic-Tac-Toe OOP game for the Tealeaf Course C1-L2
# (Anton Malkov)

# Creates a player attached to a particular board and using a specified marker
class Player
  attr_accessor :marker, :board, :points, :name

  def initialize(board, marker = '?')
    @marker = marker
    @board = board
    @points = 0
  end
end

# Creates a human player and let's him choose moves via command line
class Human < Player
  def move
    prompt_for_move
    loop do
      the_move = gets.chomp.downcase
      if board.empty_squares.include? the_move
        board[the_move] = marker
        break
      end
      ask_to_choose_an_empty_square
    end
  end

  private

  def prompt_for_move
    puts "\nWhere do you want to move?"
    puts "(type row letter followed by the column number (like 'B2')\n\n"
    print '>> '
  end

  def ask_to_choose_an_empty_square
    puts "\nPlease, choose one of the following options:"
    puts board.empty_squares.join_or
    puts
    print '>> '
  end
end

# Creates a computer player and let's him choose a random move
#   or smart move using the minimax algorythm
class Computer < Player
  attr_accessor :opponent_marker

  DUMB_MOVE_PROBABILITY = 10

  def move
    if rand(100) <= DUMB_MOVE_PROBABILITY
      board[random_move] = marker
    else # otherwise use minimax algorythm
      board[smart_move] = marker
    end
  end

  private

  def random_move
    board.empty_squares.sample
  end

  def smart_move
    weights = all_move_weights(board, marker)
    best_weight = weights.values.max
    weights.select { |_, v| v == best_weight }.keys.sample
  end

  def all_move_weights(board_state, next_marker)
    weights = {}
    board_state.empty_squares.each do |move|
      new_board_state = Board.new board_state.squares_with(move, next_marker)
      weights.merge! move => minimax(new_board_state, next_marker)
    end
    weights
  end

  def move_weight(board_state)
    if board_state.winning_marker == marker
      return 1
    elsif board_state.someone_won? # not nil and not equal to computer marker
      return -1
    else
      return 0
    end
  end

  def minimax(board_state, current_marker)
    # If game is over because someone won or because the board is full
    # then stop weighing subsecuent moves and return the weight of the last move
    if board_state.full? || board_state.someone_won?
      return move_weight(board_state)
    end

    # Cycle markers for each subsequent move
    next_move_marker = the_other_marker(current_marker)

    # Weight all possible subsecuent moves
    move_weights = all_move_weights(board_state, next_move_marker)
    if next_move_marker == marker # It's computer's move. Choose the best one.
      return move_weights.values.max
    else # It's human's move. Choose the one that is worst for the computer.
      return move_weights.values.min
    end
  end

  def the_other_marker(current_marker)
    ([marker, opponent_marker] - [current_marker]).first
  end
end

# Takes care of the state of on square of a board
class Square
  attr_accessor :marker

  EMPTY_MARKER = '.'.light_black

  def initialize(marker = EMPTY_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == EMPTY_MARKER
  end

  def marked?
    marker != EMPTY_MARKER
  end

  def to_s
    marker
  end
end

# Creates, displays and tracks board state (markers in each square)
class Board
  attr_accessor :squares
  SQUARE_NAMES = %w(a1 a2 a3 b1 b2 b3 c1 c2 c3)
  WIN_LINES = %w(a1-a2-a3 b1-b2-b3 c1-c2-c3) + # rows
              %w(a1-b1-c1 a2-b2-c2 a3-b3-c3) + # columns
              %w(a1-b2-c3 c1-b2-a3) # diagonals

  def initialize(new_squares = {})
    @squares = {}
    if new_squares == {}
      reset
    else
      @squares = new_squares
    end
  end

  def []=(square, marker)
    @squares[square].marker = marker
  end

  def empty_squares
    squares.select { |_, square| square.unmarked? }.keys
  end

  # rubocop:disable Metrics/AbcSize, MethodLength
  def to_s
    <<-STR

       |   1   |   2   |   3   |
    ---+-------+-------+-------+
       |       |       |       |
     A |   #{squares['a1']}   |   #{squares['a2']}   |   #{squares['a3']}   |
       |       |       |       |
    ---+-------+-------+-------+
       |       |       |       |
     B |   #{squares['b1']}   |   #{squares['b2']}   |   #{squares['b3']}   |
       |       |       |       |
    ---+-------+-------+-------+
       |       |       |       |
     C |   #{squares['c1']}   |   #{squares['c2']}   |   #{squares['c3']}   |
       |       |       |       |
    ---+-------+-------+-------+
    STR
  end
  # rubocop:enable Metrics/AbcSize, MethodLength

  def display
    puts self
  end

  def winning_marker
    WIN_LINES.each do |line|
      line_squares = squares.values_at(*line.split('-'))
      line_markers = line_squares.select(&:marked?).collect(&:marker)
      next if line_markers.size < 3
      return line_markers[0] if line_markers.all? { |v| v == line_markers[0] }
    end
    nil
  end

  def someone_won?
    !winning_marker.nil?
  end

  def full?
    empty_squares.empty?
  end

  def squares_with(square, marker)
    squares.merge square => Square.new(marker)
  end

  def reset
    SQUARE_NAMES.each { |square| @squares[square] = Square.new }
  end
end

# Controls Tick Tack Toe game flow
class TTT
  attr_accessor :human, :computer, :board, :current_marker

  MAX_POINTS = 5
  # must be either 'human' or 'computer' instance variable names
  FIRST_TO_MOVE = 'human'

  def initialize
    @board = Board.new
    @human = Human.new(board)
    @computer = Computer.new(board)
  end

  def play
    welcome
    choose_names_and_markers
    loop do
      play_one_round
      finish_game if game_over?
      puts "\n=> Do you want to play again? (y/n)\n\n"
      print '>> '
      break unless gets.chomp.downcase == 'y'
    end
    finish_game
  end

  private

  # NAMES:

  def choose_names_and_markers
    choose_player_names
    choose_markers
  end

  def choose_player_names
    choose_human_name
    choose_computer_name
  end

  def choose_human_name
    name = ''
    loop do
      puts "What is your name?\n\n"
      print '>> '
      name = gets.chomp.capitalize
      break if name =~ /\S/
      puts 'Pardon?'
    end
    human.name = name
  end

  def choose_computer_name
    available_names = ['R2D2', 'Wall-E', 'T-800'] - [human.name]
    computer.name = available_names.sample
  end

  # MARKERS:

  def choose_markers
    choose_human_marker
    choose_computer_marker
    reset_current_marker
  end

  def choose_human_marker
    marker = ''
    loop do
      prompt_for_marker
      marker = gets.chomp.upcase[0]
      break if visible?(marker) && marker != Square::EMPTY_MARKER.uncolorize
    end
    human.marker = marker.green
  end

  def prompt_for_marker
    puts "\nWhich marker would you like to use?"
    if visible?(Square::EMPTY_MARKER)
      puts '(Choose any visible character ' \
           "except for '#{Square::EMPTY_MARKER.uncolorize}')\n\n"
    else
      puts "(Choose any visible character)\n\n"
    end
    print '>> '
  end

  def visible?(char)
    char =~ /\A\S/
  end

  def choose_computer_marker
    taken_markers = [human.marker.uncolorize, Square::EMPTY_MARKER.uncolorize]
    available_markers = ['O', 'X', '*'] - taken_markers
    computer.marker = available_markers.first.red
    computer.opponent_marker = human.marker
  end

  def reset_current_marker
    @current_marker = instance_variable_get('@' + FIRST_TO_MOVE).marker
  end

  # GAME FLOW:

  def play_one_round
    reset
    loop do
      current_player_moves
      break if round_over?
    end
    count_points
    display_round_result
  end

  def current_player_moves
    case current_marker
    when human.marker
      human.move
      @current_marker = computer.marker
    when computer.marker
      computer.move
      @current_marker = human.marker
    end
    display_board
  end

  def round_over?
    board.full? || board.someone_won?
  end

  def human_won_round?
    board.winning_marker == human.marker
  end

  def computer_won_round?
    board.winning_marker == computer.marker
  end

  def game_over?
    human_won_game? || computer_won_game?
  end

  def human_won_game?
    human.points == MAX_POINTS
  end

  def computer_won_game?
    computer.points == MAX_POINTS
  end

  def count_points
    human.points += 1 if human_won_round?
    computer.points += 1 if computer_won_round?
  end

  def reset
    board.reset
    display_board
    reset_current_marker
  end

  def finish_game
    display_game_result
    goodbye
    exit
  end

  # DISPLAY:

  def display_board
    clear
    display_points
    board.display
  end

  def clear
    system('clear') || system('cls')
  end

  def display_points
    puts "\n #{human.name}: #{human.points}  vs.  " \
         "#{computer.name}: #{computer.points}\n"
  end

  def display_round_result
    display_round_message
    display_points
  end

  def display_round_message
    if human_won_round?
      puts "\n *** #{human.name} WON ***".green
    elsif computer_won_round?
      puts "\n *** #{human.name} LOST ***".red
    else
      puts "\n *** IT'S A TIE ***".yellow
    end
  end

  def display_game_result
    if human_won_game?
      puts "\nGAME OVER: Congratulations, #{human.name} WON!!!".light_green.bold
      sleep 3
    elsif computer_won_game?
      puts "\nGAME OVER: Sorry, #{human.name} LOST!!!".red.bold
      sleep 3
    end
  end

  # rubocop:disable Metrics/AbcSize
  def welcome
    clear
    puts "\n" * 10 +
      'Welcome to the TIC-TAC-TOE Game!'.center(80).light_blue.bold + "\n\n" +
      '* * *'.center(80) + "\n\n" +
      '(c) Anton Malkov'.center(80).light_green
    sleep 1
    clear
  end
  # rubocop:enable Metrics/AbcSize

  def goodbye
    clear
    puts "\n" * 10 +
      "Thanks for playing, #{human.name}!".center(80).light_blue.bold + "\n\n" +
      'See you next time!'.center(80).light_green
    sleep 2
    clear
  end
end

class Array
  def join_or(delimiter = ', ', last_delimiter = 'or')
    return self[0] if self.size < 2
    self[0..-2].join(delimiter) + ' ' + last_delimiter + ' ' + self[-1].to_s
  end
end

TTT.new.play
