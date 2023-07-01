import "random" for Random

var FACES = "23456789TJQKA"
var SUITS = "shdc"

var createDeck = Fn.new {
    var cards = []
    SUITS.each { |suit| FACES.each { |face| cards.add("%(face)%(suit)") } }
    return cards
}

var dealTopDeck = Fn.new { |deck, n| deck.take(n).toList }

var dealBottomDeck = Fn.new { |deck, n| deck[-n..-1][-1..0] }

var printDeck = Fn.new { |deck|
    for (i in 0...deck.count) {
        System.write("%(deck[i])  ")
        if ((i + 1) % 13 == 0 || i == deck.count - 1) System.print()
    }
}

var deck = createDeck.call()
System.print("After creation, deck consists of:")
printDeck.call(deck)
Random.new().shuffle(deck)
System.print("\nAfter shuffling, deck consists of:")
printDeck.call(deck)
var dealtTop = dealTopDeck.call(deck, 10)
System.print("\nThe 10 cards dealt from the top of the deck are:")
printDeck.call(dealtTop)
var dealtBottom = dealBottomDeck.call(deck, 10)
System.print("\nThe 10 cards dealt from the bottom of the deck are:")
printDeck.call(dealtBottom)
