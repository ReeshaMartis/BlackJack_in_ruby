class Player
    attr_accessor :name, :hand
    def initialize(name)
        @name = name
        @hand = []
    end

    def hit(card)
        @hand.push(card)
    end

    def stand
        # Game logic handles this
    end

    def bust?
        score>21
    end
    def blackjack?
        score==21
    end
    def score
        total = 0
        aces = 0
        @hand.each do |card|
            if ['K','Q','J'].include?(card)
                total += 10 
            elsif card == 'A'
                total += 11 
                aces +=1
            else
                total += card.to_i
            end
        end
        #adjusting aces if total > 21
        while total >21 && aces >0
                total-=10
                aces-=1
        end
        total    
    end
end

class Deck
    attr_accessor :cards

    def initialize
        @cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']*4
        @cards.shuffle!
    end
      # Remove and return one card from the deck
    def deal
        @cards.pop
    end
end

class Gameplay
    def initialize(player_name)
        @player = Player.new(player_name)
        @dealer = Player.new("Dealer")
        @deck = Deck.new

        # Deal initial 2 cards to each
        2.times {@player.hit(@deck.deal)} 
        2.times {@dealer.hit(@deck.deal)}
    end

    def game
        puts "Player #{@player.name} has cards #{@player.hand} with current score #{@player.score}"
        puts "Dealer #{@dealer.name}'s first shown card #{@dealer.hand.first} "

        player_turn

        if @player.bust?
            puts "you busted , Dealer wins"
            return
        elsif @player.blackjack?
            puts "Blackjack! You win!"
            return
        end
        
        dealer_turn

        determine_winner
    end

    private

    def player_turn
        loop do
            puts "hit or stay?(h/s)"
            choice = gets.chomp.downcase
            if choice == 'h'
                card = @deck.deal
                @player.hit(card)
                puts "You drew #{card}. Current hand: #{@player.hand.join(', ')} (Score: #{@player.score})"

                break if @player.bust?|| @player.blackjack?
            elsif choice == 's'
                puts "you chose to stand"
                break
            else
                puts "invalid input try again. Please enter 'h' or 's' "
            end
        end
    end
# Dealer automatically hits until 17 or higher
    def dealer_turn
        puts "Dealer #{@dealer.name} has cards #{@dealer.hand.join(',')} with score #{@dealer.score}"
        while @dealer.score < 17
            card = @deck.deal
            @dealer.hit(card)
            puts "Dealer #{@dealer.name} has cards #{@dealer.hand.join(',')} with score #{@dealer.score}"
        end
        if @dealer.bust?
            puts "Dealer busted! You win!"
        end
    end


    def determine_winner
        return if @dealer.bust?  # already printed “Dealer busted”

        player_score = @player.score
        dealer_score = @dealer.score

        # Blackjack checks
        if @player.blackjack? && @dealer.blackjack?
            puts "Both got Blackjack! It's a tie!"
        elsif @dealer.blackjack?
            puts "Dealer has Blackjack! Dealer wins!"
        elsif player_score > dealer_score
            puts "You win! #{@player.score} vs Dealer's #{@dealer.score}"
        elsif player_score < dealer_score
            puts "Dealer wins! #{@player.score} vs Dealer's #{@dealer.score}"
        else
            puts "It's a tie! #{@player.score} vs Dealer's #{@dealer.score}"
        end
    end

end

# ---- Start the game ----
puts "Enter your name:"
player_name = gets.chomp

game = Gameplay.new(player_name)
game.game
