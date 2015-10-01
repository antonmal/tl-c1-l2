require 'pry'
require 'colorize'

class Player
  attr_accessor :the_move

  def move
    begin
      puts
      puts "=> (P)aper, (R)ock or (S)cissors?"
      @the_move = gets.chomp.downcase
    end until PRS::OPTIONS.keys.include? the_move
    print "\nYou chose:       "
    print "#{PRS::OPTIONS[the_move].upcase}\n\n".light_cyan
  end

  def to_s
    self.the_move
  end

end

class Computer < Player
  def move
    @the_move = PRS::OPTIONS.keys.sample
    print "Computer chose:  "
    sleep 1
    print "#{PRS::OPTIONS[the_move].upcase}\n\n".yellow
  end
end

class PRS
  attr_accessor :player, :computer

  OPTIONS = { "p" => "paper", "r" => "rock", "s" => "scissors" }

  def initialize
    @player = Player.new
    @computer = Computer.new
  end

  def clear
    system('clear') || system('cls')
  end

  def play
    clear
    puts "\nWelcome to Paper-Rock-Scissors game!\n\n"
    puts "Let's start...\n\n"
    sleep 1

    begin
      clear
      player.move
      computer.move
      puts result
      puts "\n=> Do you want to play again? (y/n)".light_black.bold
    end while gets.chomp.downcase == "y"
  end

  def result
    case "#{player}#{computer}"
    when 'pr', 'rs', 'sp'
      "*** YOU WON ***".light_green.bold
    when 'ps', 'rp', 'sr'
      "*** YOU LOST ***".light_red.bold
    else
      "*** IT'S A TIE ***".light_green.bold
    end
  end
end

# Play the game

PRS.new.play


