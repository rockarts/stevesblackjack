require 'rspec'
require_relative '../player'

describe Player do
    it "returns 5 for total when cards are 2 and 3" do
        player = Player.new
        player.add_card(Card.new(nil, 2, nil))
        player.add_card(Card.new(nil, 3, nil))

        expect(player.total).to eq(5)
    end
    
    it "returns 21 for total when cards are 1 and 10" do
        player = Player.new
        player.add_card(Card.new(nil, 1, nil))
        player.add_card(Card.new(nil, 10, nil))

        expect(player.total).to eq(21)
    end
    
    it "returns 16 for total when cards are 1, 10 and 5" do
        player = Player.new
        player.add_card(Card.new(nil, 1, nil))
        player.add_card(Card.new(nil, 7, nil))
        expect(player.total).to eq(18)

        player.add_card(Card.new(nil, 5, nil))
        expect(player.total).to eq(13)
    end
end
