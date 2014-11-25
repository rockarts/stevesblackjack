class Deck
	attr_accessor :cards
	def initialize(cards = [])
		@cards = cards
		(0..12).each do |x| 
			Suits.new.suits.each { |suit| @cards << Card.new(suit, x)}
		end		
	end

	def shuffle
		@cards.shuffle!
	end
end

class Card
	attr_accessor :suit, :value, :image

	def initialize(suit, value, image)
		@suit = suit
		@value = value
        	@image = image
	end
end

class Suits
	attr_accessor :suits

	def initialize
		@suits = ["clubs", "spades", "hearts", "diamonds"]
	end

end

class DrawableCard
	attr_accessor :image, :card

	def initialize(image, card)
		@image = image
		@card = card
	end

	def card_image(card)

	end
end
