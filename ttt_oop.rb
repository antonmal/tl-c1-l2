require 'pry'
require 'colorize'

# Tic-Tac-Toe OOP game for the Tealeaf Course C1-L2
# (Anton Malkov)


class Player
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def move(board)
    puts "\n=> Where do you want to move?"
    puts "   (type row letter followed by the column number (like 'B2')"
    loop do
      the_move = gets.chomp.downcase
      if board.empty_squares.include? the_move
        board[the_move] = marker
        break
      end
      puts "\n=> Please, choose one of the following options:"
      puts board.empty_squares.join(", ")
    end
  end
end

class Computer
  attr_accessor :marker
  DUMB_MOVE_PROBABILITY = 10

  def initialize(marker)
    @marker = marker
  end

  def move(board)
    if rand(100) <= DUMB_MOVE_PROBABILITY
      board[board.empty_squares.sample] = marker

    else # otherwise use minimax algorythm
      move_weights = {} # a hash of weights for each available move

      # Populate the weights hash, recursing as needed
      board.empty_squares.each do |move|
        new_board_state = Board.new( board.squares_with(move, marker) )
        move_weights.merge!( { move => minimax(new_board_state, marker) } )
      end

      # Choose and make the move with the best potential result (weight)
      best_weight = move_weights.values.max
      best_move = move_weights.key(best_weight)

      board[best_move] = marker
    end
  end

  def move_weight(board)
    if board.winning_marker == marker
      return 1
    elsif board.someone_won? # not nil and not equal to computer marker
      return -1
    else
      return 0
    end
  end

  def minimax(board, m)
    # If game is over because someone won or because the board is full
    #   then stop weighing subsecuent moves and return the weight of the last move
    return move_weight(board) if board.full? || board.someone_won?

    # Cycle markers for each subsequent move
    next_move_marker = (TTT.markers - [m]).first
    move_weights = {} # a hash of weights for each available move

    # Populate the weights array, recursing as needed
    board.empty_squares.each do |move|
      new_board_state = Board.new( board.squares_with(move, next_move_marker) )
      move_weights.merge!( { move => minimax(new_board_state, next_move_marker) } )
    end

    # Do the min or the max calculation
    #   depending on whose move it is.
    if next_move_marker == marker # It's computer's move
        return move_weights.values.max
    else
        return move_weights.values.min
    end
  end
end

class Board
  attr_accessor :squares
  SQUARE_NAMES = %w(a1 a2 a3 b1 b2 b3 c1 c2 c3)
  WIN_LINES = %w(a1-a2-a3 b1-b2-b3 c1-c2-c3 a1-b1-c1 a2-b2-c2 a3-b3-c3 a1-b2-c3 c1-b2-a3)

  def initialize(new_squares = {})
    if new_squares == {}
      @squares = {}
      reset
    else
      @squares = new_squares
    end
  end

  def []=(square, marker)
    @squares[square] = marker
  end

  def empty_squares
    squares.select { |_,v| v == TTT::EMPTY_MARKER }.keys
  end

  def to_s
    str  = "\n"
    str += "    | 1 | 2 | 3 |\n"
    str += " ---+---+---+---+\n"
    str += "  A | #{squares['a1']} | #{squares['a2']} | #{squares['a3']} |\n"
    str += " ---+---+---+---+\n"
    str += "  B | #{squares['b1']} | #{squares['b2']} | #{squares['b3']} |\n"
    str += " ---+---+---+---+\n"
    str += "  C | #{squares['c1']} | #{squares['c2']} | #{squares['c3']} |\n"
    str += " ---+---+---+---+\n"
  end

  def winning_marker
    WIN_LINES.each do |line|
      line_values = squares.values_at(*line.split('-'))
      next if line_values[0] == TTT::EMPTY_MARKER
      return line_values[0] if line_values.all? { |v| v == line_values[0] }
    end
    nil
  end

  def someone_won?
    !!winning_marker
  end

  def full?
    empty_squares.empty?
  end

  def squares_with(square, marker)
    squares.merge( {square => marker} )
  end

  def reset
    SQUARE_NAMES.each { |square| @squares[square] = TTT::EMPTY_MARKER }
  end

end


class TTT
  attr_accessor :player, :computer, :board, :current_marker

  EMPTY_MARKER = ' '
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER

  def initialize
    @player = Player.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
    @board = Board.new
    @current_marker = FIRST_TO_MOVE
  end

  def self.markers
    [HUMAN_MARKER, COMPUTER_MARKER]
  end

  def play
    welcome
    begin
      play_one_game
      puts "\n=> Do you want to play again? (y/n)"
    end while gets.chomp.downcase == "y"
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
    clear
    puts board
    @current_marker = FIRST_TO_MOVE
  end

  def play_one_game
    reset
    begin
      current_player_moves
    end until over?
    puts result
  end

  def current_player_moves
    case current_marker
    when HUMAN_MARKER
      player.move(board)
      @current_marker = COMPUTER_MARKER
    when COMPUTER_MARKER
      computer.move(board)
      @current_marker = HUMAN_MARKER
    end
    clear
    puts board
  end

  def welcome
    clear
    puts "\n" * 10
    puts "Welcome to the TIC-TAC-TOE Game!".center(80).light_blue.bold
    puts
    puts "* * *".center(80)
    puts
    puts "(c) Anton Malkov".center(80).light_green
    sleep 1
    clear
  end

  def goodbye
    clear
    puts "\n" * 10
    puts "Thanks for playing!".center(80).light_blue.bold
    puts
    puts "See you next time!".center(80).light_green
    sleep 1
    clear
  end
end

TTT.new.play
