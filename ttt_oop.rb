require 'pry'
require 'colorize'

# Tic-Tac-Toe OOP game for the Tealeaf Course C1-L2
# (Anton Malkov)

# Creates a player attached to a particular board and using a specified marker
class Player
  attr_accessor :marker, :board

  def initialize(marker, board)
    @marker = marker
    @board = board
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
    puts "\n=> Where do you want to move?"
    puts "   (type row letter followed by the column number (like 'B2')"
  end

  def ask_to_choose_an_empty_square
    puts "\n=> Please, choose one of the following options:"
    puts board.empty_squares.join(', ')
  end
end

# Creates a computer player and let's him choose a random move
#   or smart move using the minimax algorythm
class Computer < Player
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
    (TTT.markers - [current_marker]).first
  end
end

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
  attr_accessor :player, :computer, :board, :current_marker

  HUMAN_MARKER = 'X'.green
  COMPUTER_MARKER = 'O'.red
  FIRST_TO_MOVE = HUMAN_MARKER

  def initialize
    @board = Board.new
    @player = Human.new(HUMAN_MARKER, board)
    @computer = Computer.new(COMPUTER_MARKER, board)
    @current_marker = FIRST_TO_MOVE
  end

  def self.markers
    [HUMAN_MARKER, COMPUTER_MARKER]
  end

  def play
    welcome
    loop do
      play_one_game
      puts "\n=> Do you want to play again? (y/n)"
      break unless gets.chomp.downcase == 'y'
    end
    goodbye
  end

  private

  def clear
    system('clear') || system('cls')
  end

  def over?
    board.full? || board.someone_won?
  end

  def result
    case board.winning_marker
    when HUMAN_MARKER
      "\n *** YOU WON ***".green.bold
    when COMPUTER_MARKER
      "\n *** YOU LOST ***".red.bold
    else
      "\n *** IT'S A TIE ***".yellow.bold
    end
  end

  def reset
    board.reset
    clear
    puts board
    @current_marker = FIRST_TO_MOVE
  end

  def play_one_game
    reset
    loop do
      current_player_moves
      break if over?
    end
    puts result
  end

  def current_player_moves
    case current_marker
    when HUMAN_MARKER
      player.move
      @current_marker = COMPUTER_MARKER
    when COMPUTER_MARKER
      computer.move
      @current_marker = HUMAN_MARKER
    end
    clear
    puts board
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
      'Thanks for playing!'.center(80).light_blue.bold + "\n\n" +
      'See you next time!'.center(80).light_green
    sleep 1
    clear
  end
end

TTT.new.play
