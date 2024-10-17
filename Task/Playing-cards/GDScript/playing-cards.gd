class_name Base_Card

extends Node

const Suit = { Diamonds = "♦", Spades = "♠", Hearts = "♥", Clubs = "♣"}

const Rank = { Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Ten = "10", Jack = "J", Queen = "Q", King = "K", Ace = "A" }

# Test
var display = Rank.Two + Suit.Spades

# Ready Function
func _ready():
	#PlayingCard.new(Rank.Ace, Suit.Diamond)
	#print ( "display card "  + display )
	Deck.new()

class PlayingCard:
	var r
	var s

	func _init(rank, suit):
		r = rank
		s = suit
		#_to_string()

	func _to_string():
		print("Your card is the " + r + " of " + s)

class Deck:
	var cards = []
	var suits = Suit.duplicate()
	var ranks = Rank.duplicate()
	# TODO: Dynamically change the number of hands
	var hand0 = []
	var hand1 = []
	var hand2 = []
	var hand3 = []
	var hands = [hand0, hand1, hand2, hand3]
	func _init():
		for rank in ranks:
			for suit in suits:
				cards.append(PlayingCard.new(rank, suit))

		# TODO: Add Jokers
		shuffle()
		deal()
		print("************** Hand 0 ***************")
		displayHand(hands[0])
		print("************** Hand 1 ***************")
		displayHand(hands[1])
		print("************** Hand 2 ***************")
		displayHand(hands[2])
		print("************** Hand 3 ***************")
		displayHand(hands[3])


	func displayDeck():
		for card in cards:
			card._to_string()

	func shuffle():
		cards.shuffle()

	func deal():
		while cards:
			for hand in hands:
				hand.append(cards.pop_back())

	func displayHand(hand):
			for card in hand:
				card._to_string()
