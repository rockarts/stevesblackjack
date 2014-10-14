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
                if(card.value == 1) then
                    if(@total + 11 <= 21) then
                        @total += 11
                        puts @total
                        return @total
                    end
                end
                @total += card.value
            end    
        end
        
        @total
    end
end


