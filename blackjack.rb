require 'gosu'
require './cards'

class Player
    attr_accessor :hand

    def initialize(hand = [])
        @hand = hand
    end

    def add_card(card)
        @hand << card
    end

    def total
        @total = 0
        @hand.each do |card|
            if(card.value > 10)
                @total += 10
            else
                @total += card.value
            end    
        end
        @total
    end
end

class Dealer
    attr_accessor :player

    def initialize(player)
        @player = player
    end

    def add_card(card)
        @player.add_card(card)
    end

    def hand
        @player.hand
    end

    def total
        @player.total
    end

end

#Dealer Rules
# Must hit until total is >= 17

class GameWindow < Gosu::Window
	attr_accessor :player, :dealer
    
    HIT_BUTTON_X = 220
    HIT_BUTTON_Y = 240

    STAND_BUTTON_X = 370
    STAND_BUTTON_Y = 240

    def initialize
		super 640, 480, false
		self.caption = "Steve's Blackjack"
		@cursor = Gosu::Image.new(self, 'cursor.png')
        @background_image = Gosu::Image.new(self, "tsuitedfelt.jpg", true)
        @hit_button = Gosu::Image.new(self, "hit.png", true)  
        @stand_button = Gosu::Image.new(self, "stand.png", true)  
		init_cards
        @player = Player.new
        @dealer = Dealer.new(Player.new)
        deal(@player)
        deal(@player)
        deal(@dealer)
	end

	def update

	end

	def draw
		@background_image.draw(0, 0, 0)
        starting_location = 147
        @player.hand.each do |card| 
            starting_location +=  73
            card.image.draw(starting_location, 380, 0)
        end

        starting_location = 147
        @dealer.hand.each do |card|
            starting_location += 73
            card.image.draw(starting_location, 0, 0)
        end

        @hit_button.draw(HIT_BUTTON_X, HIT_BUTTON_Y, 0)
        @stand_button.draw(STAND_BUTTON_X, STAND_BUTTON_Y, 0)
        
        @cursor.draw(self.mouse_x, self.mouse_y, 0)
	end

    def hit
        deal(@player)
        win_test
    end

    def win_test
        
        if(@player.total > 21)
            #End Game state
            puts "Bust"
        end
        puts @player.total
    end

    def stand
        deal(@dealer)

        if((@dealer.total >= 17 && @dealer.total <= 21) || @dealer.total > 21) then
            #End Game State
            puts "stop dealing"
            return
        else
            stand
        end
    end

    def check_winner
        if @dealer.total > 21 then
            puts "Player win"
        end

        if @player.total > @dealer.total then
            #player win state
            puts "player win"
        end

        if @player.total == @dealer.total then
            puts "push"
        end

        if @dealer.total > @player.total then
            puts "dealer win"
        end
    end

    def button_down(id)
        if id == Gosu::KbEscape
            close
        end

        if button_down?(Gosu::MsLeft)
        
            if(mouse_x > HIT_BUTTON_X && mouse_x < HIT_BUTTON_X + 100) then
                if(mouse_y > HIT_BUTTON_Y && mouse_y < HIT_BUTTON_Y + 50) then
                    puts "hit button!"
                    hit
                end
            end

            if(mouse_x > STAND_BUTTON_X && mouse_x < STAND_BUTTON_X + 100)
            then
                if(mouse_y > STAND_BUTTON_Y && mouse_y < STAND_BUTTON_Y + 50)
                then
                    stand
                    check_winner
                end
            end

            puts "HIT_X #{HIT_BUTTON_X} HIT Y #{HIT_BUTTON_Y}"
            puts "mouse click #{mouse_x}, #{mouse_y}"
        end
    end

	def init_cards
		@card_images = Gosu::Image.load_tiles(self, "cards.png", 73, 98, true)
        @deck = []

		@card_images.each_slice(13) do |ary|
			ary.each_with_index do |x, i|
				@deck << Card.new(nil, i + 1, x)
			end
		end
	end

    def deal(player)
        card = @deck.sample
        @deck.delete(card)
        player.add_card(card)
    end
end


window = GameWindow.new
window.show
