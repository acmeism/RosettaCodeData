import "random" for Random

var rand = Random.new()

var snl = {
     4: 14,  9: 31, 17:  7, 20: 38, 28: 84, 40: 59, 51: 67, 54: 34,
    62: 19, 63: 81, 64: 60, 71: 91, 87: 24, 93: 73, 95: 75, 99: 78
}

var sixThrowsAgain = true

var turn = Fn.new { |player, square|
    while (true) {
        var roll = 1 + rand.int(6)
        System.write("Player %(player), on square %(square), rolls a %(roll)")
        if (square + roll > 100) {
            System.print(" but cannot move.")
        } else {
            square = square + roll
            System.print(" and moves to square %(square).")
            if (square == 100) return 100
            var next = snl[square]
            if (!next) next = square
            if (square < next) {
                System.print("Yay! Landed on a ladder. Climb up to %(next).")
                if (next == 100) return 100
                square = next
            } else if (square > next) {
                System.print("Oops! Landed on a snake. Slither down to %(next).")
                square = next
            }
        }
        if (roll < 6 || !sixThrowsAgain) return square
        System.print("Rolled a 6 so roll again.")
    }
}

// three players starting on square one
var players = [1, 1, 1]
while (true) {
    var i = 0
    for (s in players) {
        var ns = turn.call(i + 1, s)
        if (ns == 100) {
            System.print("Player %(i+1) wins!")
            return
        }
        players[i] = ns
        System.print()
        i = i + 1
    }
}
