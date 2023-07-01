struct Card: CustomStringConvertible
{
	enum Suit: String, CaseIterable, CustomStringConvertible
	{
		case clubs = "♣️"
		case diamonds = "♦️"
		case hearts = "♥️"
		case spades = "♠️"

		var description: String { rawValue }
	}

	let suit: Suit
	let value: Int

	var description: String
	{
		let valueAsString: String
		switch value
		{
		case 1:
			valueAsString = "A"
		case 11:
			valueAsString = "J"
		case 12:
			valueAsString = "Q"
		case 13:
			valueAsString = "K"
		default:
			valueAsString = "\(value)"
		}
		return valueAsString + suit.description
	}
}

struct Deck: CustomStringConvertible
{
	var cards: [Card] = []

	init()
	{
		for suit in Card.Suit.allCases
		{
			for faceValue in 1 ... 13
			{
				cards.append(Card(suit: suit, value: faceValue))
			}
		}
	}

	var description: String
	{
		String(cards.map{ $0.description }.joined(separator: ", "))
	}

	mutating func shuffle()
	{
		cards.shuffle()
	}

	mutating func dealCard() -> Card?
	{
		guard !cards.isEmpty else { return nil }
		return cards.removeLast()
	}
}

var deck = Deck()
print("New deck:")
print(deck)
deck.shuffle()
print("Shuffled deck:")
print(deck)

var hands: [[Card]] = [[], [], [], []]

var handIndex = 0

while let card = deck.dealCard()
{
	hands[handIndex].append(card)
	handIndex = (handIndex + 1) % hands.count
}

print ("Hands:")
print(hands.map({ $0.description }).joined(separator: "\n"))
print("Remaining deck (should be empty):")
print(deck)
