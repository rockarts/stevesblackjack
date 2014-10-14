require './cards'
require './player'

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


