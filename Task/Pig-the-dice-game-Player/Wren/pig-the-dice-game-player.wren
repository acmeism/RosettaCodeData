import "random" for Random
import "os" for Process

var args = Process.arguments
var games = (args.count == 0) ? 100 : Num.fromString(args[0])

var Rand = Random.new()
var Die  = 1..6
var Goal = 100

class Player {
    construct new(strategy) {
        _score = 0
        _ante  = 0
        _rolls = 0
        _strategy = strategy
    }

    score { _score  }
    rolls { _rolls  }
    ante  { _ante   }

    score=(s) { _score = s }

    turn() {
        _rolls = 0
        _ante = 0
        while (true) {
            _rolls = _rolls + 1
            var roll = Rand.int(Die.from, Die.to + 1)
            if (roll == 1) {
                _ante = 0
                break
            }
            _ante = _ante + roll
            if (_score + _ante >= Goal || _strategy.call()) break
         }
         _score = _score + _ante
    }
}

var numPlayers = 5
var players = List.filled(numPlayers, null)

// default, go-for-broke, always roll again
players[0] = Player.new { false }

// try to roll 5 times but no more per turn
players[1] = Player.new { players[1].rolls >= 5 }

// try to accumulate at least 20 points per turn
players[2] = Player.new { players[2].ante > 20 }

// random but 90% chance of rolling again
players[3] = Player.new { Rand.float() < 0.1 }

// random but more conservative as approaches goal
players[4] = Player.new { Rand.float() < (Goal - players[4].score) * 0.6 / Goal }

var wins = List.filled(numPlayers, 0)

for (i in 0...games) {
    var player = -1
    while (true) {
        player = player + 1
        var p = players[player % numPlayers]
        p.turn()
        if (p.score >= Goal) break
    }
    wins[player % numPlayers] = wins[player % numPlayers] + 1
    System.print(players.map { |p| p.score }.join("\t"))
    players.each { |p| p.score = 0 }
}

System.print("\nSCORES: for %(games) games")
System.print(wins.join("\t"))
