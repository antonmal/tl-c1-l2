require 'pry'
require 'colorize'

# OOP Blackjack game
# for Tealeaf Course C1-L2
# (Anton Malkov)

class Card
  attr_accessor :rank, :suit
  SUITS = %w(♥ ♦ ♠ ♣)
  RANKS = %w(1 2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(rank, suit)
    RANKS.include?(rank) ? @rank = rank : exit
    SUITS.include?(suit) ? @suit = suit : exit
  end

  def to_s
    %w(♥ ♦).include?(suit) ? color_suit = suit.red : color_suit = suit.blue
    rank == '10' ? "#{rank}#{color_suit}" : "#{rank}#{color_suit} "
  end

  def rank_value
    case rank
    when '1'..'10'
      rank.to_i
    when 'J', 'Q', 'K'
      10
    when 'A'
      11
    end
  end
end

class Deck
  attr_accessor :cards
  DECKS = 6

  def initialize
    @cards = []
    Card::RANKS.each do |rank|
      Card::SUITS.each do |suit|
        @cards.push(Card.new(rank, suit))
      end
    end
    @cards *= DECKS
    @cards.shuffle!
  end

  def deal
    cards.pop
  end
end

class Player
  attr_accessor :hand, :name, :color

  def initialize(name)
    @hand = []
    @name = name.capitalize
    @color = :cyan
  end

  def hit(deck)
    self.hand << deck.deal
  end

  def to_s
    str =  ("+---+ " * hand.size + "\n").colorize(color)
    str +=  "|".colorize(color) + hand.join('| |'.colorize(color)) + "|".colorize(color)
    str +=  " = #{points}\n".colorize(color)
    str += ("+---+ " * hand.size).colorize(color)
  end

  def points
    pts = hand.map { |card| card.rank_value }.inject(:+)

    # If the sum is greater than 21 (busted), re-calculate one or more aces as 1s
    if pts > 21
      aces = hand.count { |card| card.rank == "A" }
      aces.times do
        pts -= 10
        break if pts <= 21
      end
    end
    pts
  end

  def busted?
    points > 21
  end

  def blackjack?
    points == 21
  end

end

class Dealer < Player

  def initialize
    @hand = []
    @name = "Dealer"
    @color = :yellow
  end

  def with_cards_hidden
    str =  ("+---+ " * hand.size + "\n").colorize(color)
    hand.each_with_index do |card, index|
      if index == 0
        str += "|".colorize(color) + card.to_s + "| ".colorize(color)
      else
        str += "|".colorize(color) + "XXX".light_black + "| ".colorize(color)
      end
    end
    str += "\n"
    str += ("+---+ " * hand.size).colorize(color)
  end

end

class Game
  attr_accessor :deck, :player, :dealer, :show_dealer_cards

  def initialize(player_name)
    @deck = Deck.new
    @player = Player.new(player_name)
    @dealer = Dealer.new
    2.times do
      player.hit(deck)
      dealer.hit(deck)
    end
    @show_dealer_cards = false
  end

  def play
    player_move
    self.show_dealer_cards = true
    dealer_move unless player.busted? || player.blackjack?
    puts self
    puts
    puts result
  end

  def player_move
    until player.busted? || player.blackjack?
      puts self
      puts
      puts "=> Do you want to (H)it or (S)tay?"
      hit_or_stay = gets.chomp.downcase
      player.hit(deck) if hit_or_stay == "h"
      break if hit_or_stay == "s"
    end
  end

  def dealer_move
    while dealer.points < 17
      puts self
      puts
      puts "=> Dealer is getting another card ..."
      sleep 1
      dealer.hit(deck)
    end
  end

  def evaluate_state
    if player.busted?
      dealer.busted? ? "tie busted" : "player busted"
    elsif dealer.busted?
      player.busted? ? "tie busted" : "dealer busted"
    elsif player.blackjack?
      dealer.blackjack? ? "tie blackjack" : "player blackjack"
    elsif dealer.blackjack?
      player.blackjack? ? "tie blackjack" : "dealer blackjack"
    elsif player.points == dealer.points
        "tie points"
    else
      player.points > dealer.points ? "player won" : "dealer won"
    end
  end

  def result
    case evaluate_state
      when "player blackjack"
        "*** #{player.name} WON ***  You have blackjack!".green
      when "dealer blackjack"
        "*** #{player.name} LOST ***  Dealer has blackjack!".red
      when "player busted"
        "*** #{player.name} LOST ***  Busted!".red
      when "dealer busted"
        "*** #{player.name} WON ***  Dealer busted!".green
      when "player won"
        "*** #{player.name} WON ***  You have more points!".green
      when "dealer won"
        "*** #{player.name} LOST ***  Dealer has more points!".red
      when "tie blackjack"
        "*** IT'S A TIE ***  Both have blackjack!".yellow
      when "tie busted"
        "*** IT'S A TIE ***  Both busted!".yellow
      when "tie points"
        "*** IT'S A TIE ***  You have equal number of points!".yellow
      else
        ""
    end
  end

  def self.clear
    system('clear') || system('cls')
  end

  def to_s
    Game.clear
    str = "Dealer's cards:\n"
    str += show_dealer_cards ? "#{dealer}\n\n" : "#{dealer.with_cards_hidden}\n\n"
    str += "#{player.name}'s cards:\n"
    str += "#{player}\n"
  end
end


# Play the game

Game.clear
puts "Welcome to BLACKJACK !"
puts
puts "=> What is your name?"
player_name = gets.chomp.capitalize
puts
puts "Let's start, #{player_name}..."
sleep 1

begin

  Game.new(player_name).play

  puts
  puts "=> #{player_name}, do you want to play again? (y/n)"

end while gets.chomp.downcase == "y"






