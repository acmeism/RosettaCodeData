import "./dynamic" for Enum
import "./trait" for Comparable
import "./fmt" for Fmt
import "./str" for Str
import "./math" for Nums
import "./sort" for Sort
import "random" for Random

var Color   = Enum.create("Color",   ["RED", "GREEN", "PURPLE"])
var Symbol  = Enum.create("Symbol",  ["OVAL", "SQUIGGLE", "DIAMOND"])
var Number  = Enum.create("Number",  ["ONE", "TWO", "THREE"])
var Shading = Enum.create("Shading", ["SOLID", "OPEN", "STRIPED"])
var Degree  = Enum.create("Degree",  ["BASIC", "ADVANCED"])

class Card is Comparable {
    static zero { Card.new(Color.RED, Symbol.OVAL, Number.ONE, Shading.SOLID) }

    construct new(color, symbol, number, shading) {
        _color   = color
        _symbol  = symbol
        _number  = number
        _shading = shading
        _value   = color * 27 + symbol * 9 + number * 3 + shading
    }

    color   { _color }
    symbol  { _symbol }
    number  { _number }
    shading { _shading }
    value   { _value }

    compare(other) { (_value - other.value).sign }

    toString {
        return Str.lower(Fmt.swrite("$-8s$-10s$-7s$-7s",
            Color.members  [_color],
            Symbol.members [_symbol],
            Number.members [_number],
            Shading.members[_shading]
        ))
    }
}

var createDeck = Fn.new {
    var deck = List.filled(81, null)
    for (i in 0...81) {
        var col = (i/27).floor
        var sym = (i/ 9).floor % 3
        var num = (i/ 3).floor % 3
        var shd = i % 3
        deck[i] = Card.new(col, sym, num, shd)
    }
    return deck
}

var rand = Random.new()

var isSet = Fn.new { |trio|
    var r1 = Nums.sum(trio.map { |c| c.color   }) % 3
    var r2 = Nums.sum(trio.map { |c| c.symbol  }) % 3
    var r3 = Nums.sum(trio.map { |c| c.number  }) % 3
    var r4 = Nums.sum(trio.map { |c| c.shading }) % 3
    return r1 + r2 + r3 + r4 == 0
}

var playGame = Fn.new { |degree|
    var deck = createDeck.call()
    var nCards = (degree == Degree.BASIC) ? 9 : 12
    var nSets = (nCards/2).floor
    var sets = List.filled(nSets, null)
    for (i in 0...nSets) sets[i] = [Card.zero, Card.zero, Card.zero]
    var hand = []
    while (true) {
        rand.shuffle(deck)
        hand = deck.take(nCards).toList
        var count = 0
        var hSize = hand.count
        var outer = false
        for (i in 0...hSize-2) {
            for (j in i+1...hSize-1) {
                for (k in j+1...hSize) {
                    var trio = [hand[i], hand[j], hand[k]]
                    if (isSet.call(trio)) {
                        sets[count] = trio
                        count = count + 1
                        if (count == nSets) {
                            outer = true
                            break
                        }
                    }
                }
                if (outer) break
            }
            if (outer) break
        }
        if (outer) break
    }
    Sort.quick(hand)
    System.print("DEALT %(nCards) CARDS:\n")
    System.print(hand.join("\n"))
    System.print("\nCONTAINING %(nSets) SETS:\n")
    for (s in sets) {
        Sort.quick(s)
        System.print(s.join("\n"))
        System.print()
    }
}

playGame.call(Degree.BASIC)
System.print()
playGame.call(Degree.ADVANCED)
