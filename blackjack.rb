require 'gosu'
require './cards'
require './player'
require './dealer'

class GameWindow < Gosu::Window
	attr_accessor :player, :dealer
    
    HIT_BUTTON_X = 220
    HIT_BUTTON_Y = 240

    STAND_BUTTON_X = 370
    STAND_BUTTON_Y = 240
    
    DEAL_BUTTON_X = 240
    DEAL_BUTTON_Y = 140

    def initialize
		super 640, 480, false
		self.caption = "Steve's Blackjack"
		@cursor = Gosu::Image.new(self, 'cursor.png')
        @background_image = Gosu::Image.new(self, "tsuitedfelt.jpg", true)
        @hit_button = Gosu::Image.new(self, "hit.png", true)  
        @stand_button = Gosu::Image.new(self, "stand.png", true)  
        @deal_button = Gosu::Image.new(self, "deal.png", true)  
	    reset
    end

    def reset
        init_cards
        @state = "new"
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

        if(@state == "new")
            @hit_button.draw(HIT_BUTTON_X, HIT_BUTTON_Y, 0)
            @stand_button.draw(STAND_BUTTON_X, STAND_BUTTON_Y, 0)
        end
        
        if(@state != "new")
            message = Gosu::Font.new(self, Gosu::default_font_name, 200)
            message.draw(@state, 100, 150, 1.0, 1.0, 1.0)
            @deal_button.draw(DEAL_BUTTON_X, DEAL_BUTTON_Y, 0)
        end

        @cursor.draw(self.mouse_x, self.mouse_y, 0)
	end

    def hit
        deal(@player)
        win_test
    end

    def win_test
        
        if(@player.total > 21)
            @state = "Lose"
            puts @state
        end
        
        if(@player.total == 21)
            @state = "Win"
            puts @state

        end
        puts @player.total
    end

    def stand
        deal(@dealer)

        if((@dealer.total >= 17 && @dealer.total <= 21) || @dealer.total > 21) then
            #End Game State
            puts "stop dealing"
            @state = "Win"
            puts @state
            return
        else
            stand
        end
    end

    def check_winner
        if @dealer.total > 21 then
            @state = "Win"
            puts @state
            return
        end

        if @player.total > @dealer.total then
            @state = "Win"
            puts @state
            return
        end

        if @player.total == @dealer.total then
            @state = "Push"
            puts @state
            return
        end

        if @dealer.total > @player.total then
            @state = "Lose"
            puts @state
            return
        end

    end

    def button_down(id)
        if id == Gosu::KbEscape
            close
        end

        if button_down?(Gosu::MsLeft)
            if button_pressed(HIT_BUTTON_X, HIT_BUTTON_Y) then
                hit
            end

            if button_pressed(STAND_BUTTON_X, STAND_BUTTON_Y) then
                stand
                check_winner
            end
            
            if button_pressed(DEAL_BUTTON_X, DEAL_BUTTON_Y) then
                reset
            end

        end
    end

    def button_pressed(x, y)
        return (mouse_x > x && mouse_x < x + 100) && (mouse_y > y && mouse_y < y + 50)
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
