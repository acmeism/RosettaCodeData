import Foundation

// extend any Indexed collection to be able to shuffle (see http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift)
extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }

        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

// now the model structs
enum CardColor : Int {
    case Red
    case Black
}
extension CardColor : CustomStringConvertible {
    var description : String {
        switch self {
        case .Red:
            return "Red"
        case .Black:
            return "Black"
        }
    }
}

enum Suit : Int {
    case Hearts = 1
    case Diamonds
    case Spades
    case Clubs

    var color : CardColor {
        switch self {
        case .Hearts, .Diamonds:
            return .Red
        case .Spades, .Clubs:
            return .Black
        }
    }
}

enum Pip : Int {
    case Ace = 1
    case Two = 2
    case Three = 3
    case Four = 4
    case Five = 5
    case Six = 6
    case Seven = 7
    case Eight = 8
    case Nine = 9
    case Ten = 10
    case Jack = 11
    case Queen = 12
    case King = 13
}

struct Card {
    let pip : Pip
    let suit : Suit

    var isFaceCard : Bool {
        return pip.rawValue > 10
    }

    var color : CardColor {
        return suit.color
    }
}
extension Card : Equatable {}
func == (l:Card, r:Card) -> Bool {
    return l.pip == r.pip &&
            l.suit == r.suit
}
extension Card : CustomStringConvertible {
    var description : String {
        return "\(pip) of \(suit)"
    }
}


struct Deck {
    var cards : [Card]

    var count : Int {
        return cards.count
    }

    init(shuffling:Bool=true) {
        var startcards = [Card]()
        for suit in (Suit.Hearts.rawValue...Suit.Clubs.rawValue) {
            for pip in (Pip.Ace.rawValue...Pip.King.rawValue) {
                startcards.append(Card(pip: Pip(rawValue: pip)!, suit: Suit(rawValue: suit)!))
            }
        }
        cards = startcards

        if shuffling {
            shuffle()
        }
    }

    mutating func shuffle() {
        cards.shuffleInPlace()
    }

    mutating func deal() -> Card {
        let out = cards.removeFirst()
        return out
    }

}
extension Deck : CustomStringConvertible {
    var description : String {
        return "\(count) cards: \(cards.description)"
    }
}



// test some cards
let kh = Card(pip: .King, suit: .Hearts)
let ad = Card(pip: .Ace, suit: .Diamonds)
let tc = Card(pip: .Two, suit: .Clubs)
let fc = Card(pip: Pip(rawValue:4)!, suit: .Spades)


// create an unshuffled deck
var efg =  Deck(shuffling: false)


// create a shuffled deck and print its contents
var d = Deck()
print(d)

// deal three cards
d.deal()
d.deal()
d.deal()
d

// deal a couple more cards and check their color
let c = d.deal()
c.color

let cc = d.deal()
cc.color

// deal out the rest of the deck, leaving just one card
while d.count > 1 {
    d.deal()
}
d

// test equality of a couple cards
if kh == Card(pip: Pip.King, suit: Suit.Clubs) {
    let a = true
}
else {
    let a = false
}

kh != Card(pip: Pip.King, suit: Suit.Clubs)
kh.isFaceCard
fc.isFaceCard
