# encoding: UTF-8

# Mary Dean
# 9/29/2014
# Tealeaf Course 1 Lesson 2
# Object Oriented Blackjack
# 
#=====================================
#          SPECIAL EFFECTS
#+++++++++++++++++++++++++++++++++++++

module SpecialEffects

  def self.drum_roll(dramatic_text)
    c = 0
    dramatic_text.length.times do
      print dramatic_text[c]
      c += 1
      sleep 0.04
    end
  end

  def self.clear_screen
     # It seems to work on Windows to include both of these
     # Don't know how it will work on Macs
    system 'cls'
    system 'clear'
  end

  def self.pause
    sleep(0.75)
    clear_screen
  end

  def self.show_intro
    clear_screen
    drum_roll("
    Welcome to Mary's Magnificent Emporium of...")
    show_blackjack    
    pause
    show_coin
    pause
    show_21
    pause
    show_blackjack
    pause
    show_card_hand
  end #def show_intro

  def self.show_blackjack
    puts %Q[

      _______   __                      __       
     |       \\ |  \\                    |  \\      
     | $$$$$$$\\| $$  ______    _______ | $$   __ 
     | $$__/ $$| $$ |      \\  /       \\| $$  /  \\
     | $$    $$| $$  \\$$$$$$\\|  $$$$$$$| $$_/  $$
     | $$$$$$$\\| $$ /      $$| $$      | $$   $$ 
     | $$__/ $$| $$|  $$$$$$$| $$_____ | $$$$$$\\ 
     | $$    $$| $$ \\$$    $$ \\$$     \\| $$  \\$$\\
      \\$$$$$$$  \\$$  \\$$$$$$$  \\$$$$$$$ \\$$   \\$$

         _____                      __           
        |     \\                    |  \\          
         \\$$$$$  ______    _______ | $$   __     
           | $$ |      \\  /       \\| $$  /  \\    
      __   | $$  \\$$$$$$\\|  $$$$$$$| $$_/  $$    
     |  \\  | $$ /      $$| $$      | $$   $$     
     | $$__| $$|  $$$$$$$| $$_____ | $$$$$$\\     
      \\$$    $$ \\$$    $$ \\$$     \\| $$  \\$$\\    
       \\$$$$$$   \\$$$$$$$  \\$$$$$$$ \\$$   \\$$    

    ]
   end

def self.show_coin 
  puts %Q[

         ..-"""""-..
       .'    ___    '.
      /    ."\\  `\\    \\
     ;    /, (    |    ;
    ;    /_   '._ /     ;
    |     |-  '._`)     |
    ;     '-;-'  \\      ;
     ; """" /    \\\\    ;
      \\    '.__..-'   /
       '._ 2 0 1 4 _.'
          ""-----""
]
end

def self.show_21 
  puts %Q[                                
           222222222222222      1111111        
          2:::::::::::::::22   1::::::1        
          2::::::222222:::::2 1:::::::1        
          2222222     2:::::2 111:::::1        
                      2:::::2    1::::1        
                      2:::::2    1::::1        
                   2222::::2     1::::1        
              22222::::::22      1::::l        
            22::::::::222        1::::l        
           2:::::22222           1::::l        
          2:::::2                1::::l        
          2:::::2                1::::l        
          2:::::2       222222111::::::111     
          2::::::2222222:::::21::::::::::1     
          2::::::::::::::::::21::::::::::1     
          22222222222222222222111111111111     
  ]                                               

end

  def self.show_card_hand
    #This one is a mess after escaping it, but it works!
    puts %Q{
\r\n                   __\r\n             _..-''--'----_.\r\n           ,''.-''| .---/ _`-._\r\n         ,' \\ \\  ;| | ,/ / `-._`-.\r\n       ,' ,',\\ \\( | |// /,-._  / /\r\n       ;.`. `,\\ \\`| |/ / |   )/ /\r\n      / /`_`.\\_\\ \\| /_.-.'-''/ /\r\n     / /_|_:.`. \\ |;'`..')  / /\r\n     `-._`-._`.`.;`.\\  ,'  / /\r\n         `-._`.`/    ,'-._/ /\r\n           : `-/     \\`-.._/\r\n           |  :      ;._ (\r\n           :  |      \\  ` \\\r\n            \\         \\   |\r\n             :        :   ;\r\n             |           /\r\n             ;         ,'\r\n            /         /\r\n           /         /\r\n                    / 
}
  end


end #end of module SpecialEffects


#=====================================
#           CARD
#+++++++++++++++++++++++++++++++++++++
#I didn't implement card_face_up/card_face_down
#But I will keep it for the future
 class Card
  attr_accessor :rank, :suit, :face_up
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @face_up = true
  end #initialize
  def to_s
    "#{rank} of #{suit}"
  end #to_s
  def turn_face_up
    @face_up = true
  end #turn_face_up
  def turn_face_down
    @face_up = false
  end #turn_face_down
end #class Card

#=====================================
#           DECK
#+++++++++++++++++++++++++++++++++++++
#Yes, I know all this stuff shouldn't be in here!
#It just seemed logical to put card-related methods where the
#cards were, but it grew out of control. Next version I will
#extract most of it to a separate class or module
class Deck
  attr_accessor :cards  
  SUITS = ["Hearts", "Clubs", "Spades", "Diamonds"]
  RANKS = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10","Jack","Queen","King"]

  def initialize(how_many_decks=1)
    @cards = []    
    how_many_decks.times do
      RANKS.each do |r|
        SUITS.each do |s|
          @cards << Card.new(r,s)
        end #of suits do
      end #of ranks do   
    end #how_many_decks do
  end #initialize

  def shuffle_deck
    @cards.shuffle!
  end #shuffle_deck  

  def deal(player)
    player.hand<<@cards.pop
  end 

  def deal_two_to_all(all_players) 
    puts "\n"    
    puts "Each player will receive one card before betting begins.\n\n"

    all_players.each do |p|
        deal(p)      
    end
    make_bets(all_players)
    #deal the second card
    puts "\n***************************************"
    SpecialEffects.drum_roll("All bets are in. Here is your second card...")
    puts "\n"
    all_players.each do |p|
        deal(p)      
    end
  end#def

  def make_bets(all_players)
    all_players.each do |p|
      #skip the dealer
      if p.player_num == 0 
        string_hand = p.hand.join(", ")
        puts "#{p.name}'s first card is #{string_hand}"
        next
      end
      puts "\n"
      string_hand = p.hand.join(", ")
      puts "#{p.name}, your first card is #{string_hand}."
      puts "Out of your $#{p.money_pile}, how much would you like to bet?"
      bet = gets.chomp.to_i
      if bet > p.money_pile
        puts "That's too much. Let's make it $#{p.money_pile}"
        p.bet = p.money_pile
      else
        p.bet = bet
      end #if
    end #do
  end#def

  def display_second_cards(all_players)
    puts
    all_players.each do |p|
      #p.hand is giving hideous output on Mac computers
      string_hand = p.hand.join(", ")
      puts "    #{p.name} now has #{string_hand}"
      update_score_and_status(p)
      SpecialEffects.show_21 if p.hand_status == "BLACKJACK"      
    end#do
  end#def

  def display_hand(player)
    #p.hand is giving hideous output on Mac computers
    string_hand = p.hand.join(", ")
    puts "Here is what you have, #{player.name}:  #{string_hand}"
    puts "(BLACKJACK!)" if player.hand_status == "BLACKJACK"
  end#def

  def how_many?
    @cards.count
  end

  def blackjack_value(hand)
    faces = {"Ace" =>11,
       "2" => 2, 
       "3" => 3,
       "4" => 4,
       "5" => 5,
       "6" => 6,
       "7" => 7,
       "8" => 8,
       "9" => 9,
       "10" => 10,
       "Jack" => 10,
       "Queen" => 10,
       "King" => 10
        }
    total_value = 0
    num_aces = 0    
    hand.each do |c|      
      face = c.rank
      value = faces[face]
      total_value += value
      num_aces += 1 if face == "Ace"
    end #do
    #correct for Aces
    num_aces.times do
      total_value -= 10 if total_value > 21
    end #do
  return total_value
  end #blackjack_value

  def status(player)
    bj_score = 21
    dealer_must_hit_score = 17
    current_score = blackjack_value(player.hand)
    #BLACKJACK is only relevant if the player only has two cards
    if player.hand.size == 2 && current_score == bj_score
      "BLACKJACK"
    elsif player.player_num ==0 && current_score < dealer_must_hit_score
      "DEALER MUST HIT"
    elsif current_score > bj_score
      "BUSTED"
    else
      "OK"
    end #if
  end #def

  def update_score_and_status(player)
      player.hand_score = blackjack_value(player.hand)
      player.hand_status = status(player)      
  end #def

  def deal_round(all_players)
    # problem: dealer will go first when he should be last
    # creating a temporary array with dealer at end
    # I hope this doesn't cause wrong person to receive cards
    # Another problem: where to temporarily store score/status of each player
    # I guess I will have to put those in Player    
    card_count_display    
    p_temp = all_players.rotate(1)
    p_temp.each do |p|
      puts "***************************************"
      SpecialEffects.drum_roll("        #{p.name}'s turn")
      puts "\n***************************************"      
      update_score_and_status(p)      
      #Dealer turn
      if p.player_num == 0 
          begin
            string_hand = p.hand.join(", ")
          puts "The Dealer has #{string_hand}"
          puts "It adds up to #{p.hand_score}. #{p.hand_status}"          
          if p.hand_status == "DEALER MUST HIT"            
            puts "Dealer gets a #{deal(p)[-1].to_s.upcase}"
            update_score_and_status(p)            
          end #if          
          end until p.hand_status != "DEALER MUST HIT"
          puts "Dealer is BUSTED at #{p.hand_score}!" if p.hand_status == "BUSTED"
       end #dealer turn
       #Player turn
       if p.player_num > 0 
          begin
          string_hand = p.hand.join(", ")
          puts "#{p.name}, you have #{string_hand}."
          puts "That's a BLACKJACK!" if p.hand_status == "BLACKJACK"
          puts "Your hand adds up to #{p.hand_score}. You are betting $#{p.bet}"          
          puts "What do you want to do? (H)it or (S)tay?"
          hit_or_stay = gets.chomp[0].downcase
          if hit_or_stay == "h"
            puts "#{p.name} chooses to hit... It's a #{deal(p)[-1].to_s.upcase}"
          else         
            puts "#{p.name} chooses to stay at #{p.hand_score}"
          end #if
          update_score_and_status(p)
        end until hit_or_stay != "h" || p.hand_status == "BUSTED" || p.hand_status == "BLACKJACK"          
          puts "Too bad... #{p.name} is BUSTED." if p.hand_status == "BUSTED"
        end #player turn
      end#each player do
  end#def

  def summarize_game(players)
    puts "+++++++++++++++++++++++++++++++++++++++"
    puts "        RESULTS OF THIS ROUND"
    puts "+++++++++++++++++++++++++++++++++++++++"
    dealer_status = players[0].hand_status        
    players.each do |p|
      print "#{p.name}: #{p.hand_score}"
      #dealer blackjack
        if p.hand_status == "BLACKJACK" && p.player_num == 0
          print " -- BLACKJACK!"                  
        #dealer busted 
        elsif p.hand_status == "BUSTED" && p.player_num == 0  
          print " -- BUSTED"        
          #this is important, sets dealer score to zero so others can win
          players[0].hand_score = 0
        elsif p.hand_status == "BLACKJACK" && dealer_status != "BLACKJACK"
          print " -- BLACKJACK! wins $#{p.bet*2}"
          p.money_pile = p.money_pile + (p.bet * 2)
          players[0].money_pile = players[0].money_pile - (p.bet * 2)
        elsif p.hand_status == "BUSTED"
          print " (BUSTED) Loses $#{p.bet}"
          p.money_pile = p.money_pile - p.bet
          players[0].money_pile = players[0].money_pile + p.bet
        elsif p.hand_score > players[0].hand_score
          print " -- WINS $#{p.bet}"
          p.money_pile = p.money_pile + p.bet
          players[0].money_pile = players[0].money_pile - p.bet
        elsif p.hand_score < players[0].hand_score  
          print " -- LOSES $#{p.bet}"
          p.money_pile = p.money_pile - p.bet
          players[0].money_pile = players[0].money_pile + p.bet
        #dealer shouldn't tie with himself  
        elsif p.player_num != 0 && p.hand_score == players[0].hand_score
          print " -- TIE"
        end #if
      puts "\n"      
      end #do
      puts "\n"
      puts "The dealer's balance is #{players[0].money_pile}"
    end #def


  def card_count_display
    #I cannot believe there is not a simple SUM function!
    #BUG: if you use multiple decks, this ascii table will get misaligned.
    #I could probably vary the number of spaces to fit the # of digits, but
    #I need to move on
    a = []
    RANKS.each do |r|
      a << @cards.count{|c| c.rank == r}  
      end
    puts
    puts "The deck has #{how_many?} cards left. Here is the current card count:"
    puts "======+++++==============================================================="
    puts "RANK: |  A  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  10 | Face"
    puts "--------------------------------------------------------------------------"
    puts "QTY:  |  #{a[0]}  |  #{a[1]}  |  #{a[2]}  |  #{a[3]}  |  #{a[4]}  |  #{a[5]}  |  #{a[6]}  |  #{a[7]}  |  #{a[8]}  |   #{a[9]} |  #{a[10] + a[11] +a[12]}"
    puts "======+++++==============================================================="
    puts
  end #card_count_display   

  def clear_all_hands(players)
     players.each do |p|
      p.hand = []
     end
   end #def

end #class Deck

#Hey this could be useful: array.count(2) counts all the twos
#you could do card counting
#also this: array.index()  returns the INDEX of the item you look up by value. Very useful!
#=====================================
#           PLAYER
#+++++++++++++++++++++++++++++++++++++
class Player
  @@total_players = 0
  #Because I have multiple players, it seems easier to
  #maintain their current hand and score here
  attr_accessor :player_num, :name, :money_pile, :bet, :hand, :hand_score, :hand_status
  def initialize(n)
    if n == 0 #this is the dealer
      #I will not increase @@total_players for dealer, or give him a bet
      @name = "Dealer"
      @player_num = n
      @money_pile = 0
      @bet = 0
      @hand = []
      @hand_score = 0
      @hand_status = "OK"

    elsif n == 1 #this is the first player, the one who is interacting with program
      puts "We are so glad you could come!\n"
      puts "Tell us your name, lucky player!\n\n"
      @name = gets.chomp
      puts "So, #{@name}, how much money do you want to lose today?"
      puts "Ha, just kidding. But seriously, how much do you have? (dollars)"
      @money_pile = gets.chomp.to_i    
      @player_num = n
      @hand = []
      @hand_score = 0
      @hand_status = "OK"
      @@total_players += 1
    else
      @player_num = n
      puts "What is the name of Player #{n}?"
      @name = gets.chomp
      puts "How much money does #{@name} have?"
      @money_pile = gets.chomp.to_i
      @hand = []
      @hand_score = 0
      @hand_status = "OK"
      @@total_players += 1
    end #if statement
   end #initialize 
   def to_s
      player_num == 0 ? "Dealer" : "Player #{@player_num}: #{@name}, with $#{@money_pile}."
   end
   def show_hand
    puts @cards
   end


   #Keeps count of how many players
   def self.total_players
     @@total_players
   end #self.total_players   
end #class Player


#=====================================
#       BLACKJACK GAME ENGINE
#+++++++++++++++++++++++++++++++++++++

class BlackJack
  attr_accessor :round
  def initialize
    @round = 1
  end
  def increment_round
    @round += 1
  end
  def play
    #Only show introduction, get names, and create deck if it's the first round
    if @round == 1
      SpecialEffects.show_intro
      #This is our array of players, dealer will always be p[0]
      p = []    
      p[0] = Player.new(0)
      #create the first player
      p[1] = Player.new(1)
      puts "How many other people will be playing?"
      additional_players = gets.chomp.to_i
      #the next player will be #2 and up from there
        x = 2
          additional_players.times do
        p << Player.new(x)    
        x+=1
      end # do
      puts "Great! We now have a total of #{Player.total_players} players, plus the dealer, of course."
      puts "\nHow many decks shall we play with?"    
      total_decks = gets.chomp.to_i
      deck = Deck.new(total_decks < 1 ? 1 : total_decks)
      deck.shuffle_deck
    end #if    
    begin #start of while loop
      deck.deal_two_to_all(p)
      deck.display_second_cards(p)
      deck.deal_round(p)
      deck.summarize_game(p)
      puts "Do you want to play another round? (Y)es (N)o"
      continue = gets.chomp[0].downcase    
      if continue == "y"
        deck.clear_all_hands(p)
        increment_round
        system 'cls'
        SpecialEffects.show_card_hand        
        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        puts "         STARTING ROUND #{@round}"
        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        deck.card_count_display
      else
        continue = "n"
        puts "Thank you for playing!"        
        SpecialEffects.show_blackjack
        puts "Good Bye!"
        exit    
      end #if
    end until continue == "n" #end of while loop
  end #def play
end #of class BlackJack

game = BlackJack.new
game.play