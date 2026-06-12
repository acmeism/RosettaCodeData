import "./fmt" for Fmt

var genUpsideDown = Fiber.new {
    var wrappings = [
        [1, 9], [2, 8], [3, 7], [4, 6], [5, 5],
        [6, 4], [7, 3], [8, 2], [9, 1]
    ]
    var evens = [19, 28, 37, 46, 55, 64, 73, 82, 91]
    var odds = [5]
    var oddIndex = 0
    var evenIndex = 0
    var ndigits = 1
    var pow = 100
    while (true) {
        if (ndigits % 2 == 1) {
            if (odds.count > oddIndex) {
                Fiber.yield(odds[oddIndex])
                oddIndex = oddIndex + 1
            } else {
                // build next odds, but switch to evens
                var nextOdds = []
                for (w in wrappings) {
                    for (i in odds) {
                        nextOdds.add(w[0] * pow + i * 10 + w[1])
                    }
                }
                odds = nextOdds
                ndigits = ndigits + 1
                pow = pow * 10
                oddIndex = 0
            }
        } else {
            if (evens.count > evenIndex) {
                Fiber.yield(evens[evenIndex])
                evenIndex = evenIndex + 1
            } else {
                // build next evens, but switch to odds
                var nextEvens = []
                for (w in wrappings) {
                    for (i in evens) {
                        nextEvens.add(w[0] * pow + i * 10 + w[1])
                    }
                }
                evens = nextEvens
                ndigits = ndigits + 1
                pow = pow * 10
                evenIndex = 0
            }
        }
    }
}

var limit = 5000000
var count = 0
var ud50s = []
var pow = 50
while (count < limit) {
    var n = genUpsideDown.call()
    count = count + 1
    if (count < 50) {
        ud50s.add(n)
    } else if (count == 50) {
        System.print("First 50 upside down numbers:")
        Fmt.tprint("$,5d", ud50s + [n], 10)
        System.print()
        pow = 500
    } else if (count == pow) {
        Fmt.print("$,r : $,d", pow, n)
        pow = pow * 10
    }
}
