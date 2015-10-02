require 'pry'
require 'colorize'

# Tic-Tac-Toe OOP game for the Tealeaf Course C1-L2
# (Anton Malkov)


class Player
  attr_accessor :marker

  def initialize
    @marker = "X"
  end

  def move(board)
    puts
    puts "=> Where do you want to move?"
    puts "   (type row letter followed by the colums number (like 'B2')"
    loop do
      the_move = gets.chomp.downcase
      if board.empty_cells.include? the_move
        board.hash[the_move] = self.marker
        break
      end
      puts "\n=> Please, choose one of the following options:"
      puts board.empty_cells.join(", ")
    end
  end
end

class Computer < Player

  def initialize
    @marker = "O"
  end

  def move(board)
    if rand(100) > 90 # in 10% of cases use 'dumb' random logic
      # Simple random empty cell logic
      board.hash[board.empty_cells.sample] = marker

    else # in 90% of cases use minimax AI
      
      # More complex AI logic (Minimax algorythm)
      move_weights = {} # a hash of weights for each available move

      # Populate the weights hash, recursing as needed
      board.empty_cells.each do |move|
        new_board_state = Board.new( board.hash_with(move, marker) )
        move_weights.merge!( { move => minimax(new_board_state, marker) } )
      end

      # Choose and make the move with the best potential result (weight)
      best_weight = move_weights.values.max
      best_move = move_weights.key(best_weight)

      board.hash[best_move] = marker
    end
  end

  def move_weight(board)
    if board.has_line? == marker
      return 1
    elsif board.has_line? # not nil and not equal to computer marker
      return -1
    else
      return 0
    end
  end

  def minimax(board, m)
    # If game is over because someone won or because the board is full
    #   then stop weighing subsecuent moves and return the weight of the last move
    return move_weight(board) if board.full? || board.has_line?

    # Cycle markers for each subsecuent move
    next_move_marker = (["X", "O"] - [m]).first
    move_weights = {} # a hash of weights for each available move

    # Populate the weights array, recursing as needed
    board.empty_cells.each do |move|
      new_board_state = Board.new( board.hash_with(move, next_move_marker) )
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
  attr_accessor :hash
  CELLS = %w(a1 a2 a3 b1 b2 b3 c1 c2 c3)
  WIN_LINES = %w(a1-a2-a3 b1-b2-b3 c1-c2-c3 a1-b1-c1 a2-b2-c2 a3-b3-c3 a1-b2-c3 c1-b2-a3)

  def initialize(new_hash = {})
    if new_hash == {}
      @hash = {}
      CELLS.each {|cell| @hash[cell] = " "}
    else
      @hash = new_hash
    end
  end

  def empty_cells
    hash.select {|k,v| v == " "}.keys
  end

  def to_s
    str  = "\n"
    str += "    | 1 | 2 | 3 |\n"
    str += " ---+---+---+---+\n"
    str += "  A | #{hash['a1']} | #{hash['a2']} | #{hash['a3']} |\n"
    str += " ---+---+---+---+\n"
    str += "  B | #{hash['b1']} | #{hash['b2']} | #{hash['b3']} |\n"
    str += " ---+---+---+---+\n"
    str += "  C | #{hash['c1']} | #{hash['c2']} | #{hash['c3']} |\n"
    str += " ---+---+---+---+\n"
  end

  def has_line?
    WIN_LINES.each do |line|
      ["X", "O"].each do |marker|
        return marker if line.split('-').all? {|cell| hash[cell] == marker}
      end
    end
    nil
  end

  def full?
    empty_cells.empty?
  end

  def hash_with(cell, marker)
    hash.merge( {cell => marker} )
  end

end


class TTT
  attr_accessor :player, :computer, :board

  def initialize
    @player = Player.new
    @computer = Computer.new
    @board = Board.new
  end

  def self.clear
    system('clear') || system('cls')
  end

  def over?
    board.full? || board.has_line?
  end

  def result
    case board.has_line?
    when "X"
      "*** YOU WON ***".green.bold
    when "O"
      "*** YOU LOST ***".red.bold
    else
      "*** IT'S A TIE ***".yellow.bold
    end
  end

  def play
    TTT.clear
    puts board
    begin
      player.move(board)
      TTT.clear
      puts board
      computer.move(board) unless over?
      TTT.clear
      puts board
    end until over?
    puts
    puts result
  end
end

# Welcome
TTT.clear
puts "\n" * 10
puts "Welcome to the TIC-TAC-TOE Game!".center(80).light_blue.bold
puts
puts "* * *".center(80)
puts
puts "(c) Anton Malkov".center(80).light_green
sleep 2

# Main game loop
begin
  TTT.new.play
  puts
  puts "=> Do you want to play again? (y/n)"
end while gets.chomp.downcase == "y"

# Bye-bye
TTT.clear
puts "\n" * 10
puts "Thanks for playing!".center(80).light_blue.bold
puts
puts "See you next time!".center(80).light_green
sleep 2
TTT.clear


