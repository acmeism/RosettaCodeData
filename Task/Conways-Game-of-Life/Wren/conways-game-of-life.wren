import "random" for Random
import "timer" for Timer

var Rand = Random.new(0) // using a constant seed to produce same output on each run

// patterns
var BLINKER = 0
var GLIDER  = 1
var RANDOM  = 2

class Field {
    construct new(w, h) {
        _w = w
        _h = h
        _s = List.filled(h, null)
        for (i in 0...h) _s[i] = List.filled(w, false)
    }

    [x, y]=(b) { _s[y][x] = b }

    state(x, y) {
        if (!(0..._w).contains(x) || !(0..._h).contains(y)) return false
        return _s[y][x]
    }

    next(x, y) {
        var on = 0
        for (i in -1..1) {
            for (j in -1..1) {
                 if (state(x + i, y + j) && !(j == 0 && i == 0)) on = on + 1
            }
        }
        return on == 3 || (on == 2 && state(x, y))
    }
}

class Life {
    construct new(pattern) {
        if (pattern == BLINKER) {
            _w = 3
            _h = 3
            _a = Field.new(_w, _h)
            _b = Field.new(_w, _h)
            _a[0, 1] = true
            _a[1, 1] = true
            _a[2, 1] = true
        } else if (pattern == GLIDER) {
            _w = 4
            _h = 4
            _a = Field.new(_w, _h)
            _b = Field.new(_w, _h)
            _a[1, 0] = true
            _a[2, 1] = true
            for (i in 0..2) _a[i, 2] = true
        } else if(pattern == RANDOM) {
             _w = 80
             _h = 15
             _a = Field.new(_w, _h)
             _b = Field.new(_w, _h)
            for (i in 0...(_w * _h).floor / 2) {
                _a[Rand.int(_w), Rand.int(_h)] = true
            }
        }
    }

    step() {
        for (y in 0..._h) {
            for (x in 0..._w) _b[x, y] = _a.next(x, y)
        }
        var t = _a
        _a = _b
        _b = t
    }

    toString {
        var sb = ""
        for (y in 0..._h) {
            for (x in 0..._w) {
                var c = _a.state(x, y) ? "#" : "."
                sb = sb + c
            }
            sb = sb + "\n"
        }
        return sb
    }
}

var lives = [
    [Life.new(BLINKER),  3, "BLINKER"],
    [Life.new(GLIDER),   4, "GLIDER" ],
    [Life.new(RANDOM), 100, "RANDOM" ]
]

for (t in lives) {
    var game  = t[0]
    var gens  = t[1]
    var title = t[2]
    System.print("%(title):\n")
    for (i in 0..gens) {
        System.print("Generation: %(i)\n%(game)")
        Timer.sleep(30)
        game.step()
    }
    System.print()
}
