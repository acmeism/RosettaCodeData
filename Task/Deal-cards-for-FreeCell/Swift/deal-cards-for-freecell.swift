enum Suit : String, CustomStringConvertible, CaseIterable {
    case clubs = "C", diamonds = "D", hearts = "H", spades = "S"
    var description: String {
        return self.rawValue
    }
}
enum Rank : Int, CustomStringConvertible, CaseIterable {
    case ace=1, two, three, four, five, six, seven
    case eight, nine, ten, jack, queen, king
    var description: String {
        let d : [Rank:String] = [.ace:"A", .king:"K", .queen:"Q", .jack:"J", .ten:"T"]
        return d[self] ?? String(self.rawValue)
    }
}
struct Card : CustomStringConvertible {
    let rank : Rank, suit : Suit
    var description : String {
        return String(describing:self.rank) + String(describing:self.suit)
    }
    init(rank:Rank, suit:Suit) {
        self.rank = rank; self.suit = suit
    }
    init(sequence n:Int) {
        self.init(rank:Rank.allCases[n/4], suit:Suit.allCases[n%4])
    }
}
struct Deck : CustomStringConvertible {
    var cards = [Card]()
    init(seed:Int) {
        for i in (0..<52).reversed() {
            self.cards.append(Card(sequence:i))
        }
        struct MicrosoftLinearCongruentialGenerator {
            var seed : Int
            mutating func next() -> Int {
                self.seed = (self.seed * 214013 + 2531011) % (Int(Int32.max)+1)
                return self.seed >> 16
            }
        }
        var r = MicrosoftLinearCongruentialGenerator(seed: seed)
        for i in 0..<51 {
            self.cards.swapAt(i, 51-r.next()%(52-i))
        }
    }
    var description : String {
        var s = ""
        for (ix,c) in self.cards.enumerated() {
            s.write(String(describing:c))
            s.write(ix % 8 == 7 ? "\n" : " ")
        }
        return s
    }
}
let d1 = Deck(seed: 1)
print(d1)
let d617 = Deck(seed: 617)
print(d617)
