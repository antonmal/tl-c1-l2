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

  @@log = {}
  @@stats = { won: 0, tied: 0, lost: 0, total: 0 }
  @@perc = { won: 0, tied: 0, lost: 0, total: 0 }
  OPTIONS = { "p" => "paper", "r" => "rock", "s" => "scissors" }

  def self.show_log
    @@log.each {|time,log_item| puts "#{time} - #{log_item}"}
  end

  def show_stats
    puts "\nStats:"
    puts "Won: #{@@stats[:won]} game(s) [#{@@perc[:won]}%]".light_green
    puts "Lost: #{@@stats[:lost]} game(s) [#{@@perc[:lost]}%]".light_red
    puts "Tied: #{@@stats[:tied]} game(s) [#{@@perc[:tied]}%]".light_blue
  end

  def add_to_log
    @@log[Time.now] = "#{result.to_s.upcase}: #{OPTIONS[player.to_s].capitalize} vs. #{OPTIONS[computer.to_s].capitalize}"
    @@stats[result] += 1
    @@stats[:total] += 1
    @@stats.each { |k,v| @@perc[k] = (v.to_f * 100 / @@stats[:total]).round(2) }
  end

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
      show_result
      add_to_log
      show_stats

      puts "\n=> Do you want to play again? (y/n)".white.bold
    end while gets.chomp.downcase == "y"

    clear
    PRS.show_log
  end

  def result
    case "#{player}#{computer}"
    when 'pr', 'rs', 'sp'
      :won
    when 'ps', 'rp', 'sr'
      :lost
    else
      :tied
    end
  end

  def show_result
    puts  case result
          when :won
            "*** YOU WON ***".light_green.bold
          when :lost
            "*** YOU LOST ***".light_red.bold
          else
            "*** IT'S A TIE ***".light_blue.bold
          end
  end
end

# Play the game

PRS.new.play


