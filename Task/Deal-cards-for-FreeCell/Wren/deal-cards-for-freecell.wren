class Lcg {
    construct new(a, c, m, d, s) {
        _a = a
        _c = c
        _m = m
        _d = d
        _s = s
    }

    nextInt() {
        _s = (_a * _s + _c) % _m
        return _s / _d
    }
}

var CARDS = "A23456789TJQK"
var SUITS = "♣♦♥♠".toList

var deal = Fn.new {
    var cards = List.filled(52, null)
    for (i in 0...52) {
        var card = CARDS[(i/4).floor]
        var suit = SUITS[i%4]
        cards[i] = card + suit
    }
    return cards
}

var game = Fn.new { |n|
    if (n.type != Num || !n.isInteger || n <= 0) {
        Fiber.abort("Game number must be a positive integer.")
    }
    System.print("Game #%(n):")
    var msc = Lcg.new(214013, 2531011, 1<<31, 1<<16, n)
    var cards = deal.call()
    for (m in 52..1) {
        var index = (msc.nextInt() % m).floor
        var temp = cards[index]
        cards[index] = cards[m - 1]
        System.write("%(temp) ")
        if ((53 - m) % 8 == 0) System.print()
    }
    System.print("\n")
}

game.call(1)
game.call(617)
