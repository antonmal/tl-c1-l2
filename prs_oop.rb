require 'pry'
require 'colorize'


class PRS
  attr_accessor :player, :computer

  OPTIONS = { "p" => "paper", "r" => "rock", "s" => "scissors" }

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
      player_move
      computer_move
      puts result
      puts "\n=> Do you want to play again? (y/n)".light_black.bold
    end while gets.chomp.downcase == "y"
  end

  def player_move
    begin
      puts
      puts "=> (P)aper, (R)ock or (S)cissors?"
      self.player = gets.chomp.downcase
    end until OPTIONS.keys.include? self.player
    print "\nYou chose:       "
    print "#{OPTIONS[player].upcase}\n\n".blue
  end

  def computer_move
    self.computer = OPTIONS.keys.sample
    print "Computer chose:  "
    sleep 1
    print "#{OPTIONS[computer].upcase}\n\n".yellow
  end

  def result
    case "#{player}#{computer}"
    when 'pr', 'rs', 'sp'
      "*** YOU WON ***".green.bold
    when 'ps', 'rp', 'sr'
      "*** YOU LOST ***".red.bold
    else
      "*** IT'S A TIE ***".blue.bold
    end
  end
end

# Play the game

PRS.new.play


