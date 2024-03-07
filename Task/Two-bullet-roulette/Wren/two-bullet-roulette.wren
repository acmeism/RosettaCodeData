import "random" for Random
import "./fmt" for Fmt

var Rand = Random.new()

class Revolver {
    construct new() {
        _cylinder = List.filled(6, false)
    }

    rshift() {
        var t = _cylinder[-1]
        for (i in 4..0) _cylinder[i+1] = _cylinder[i]
        _cylinder[0] = t
    }

    unload() {
        for (i in 0..5) _cylinder[i] = false
    }

    load() {
        while (_cylinder[0]) rshift()
        _cylinder[0] = true
        rshift()
    }

    spin() {
        for (i in 1..Rand.int(1, 7)) rshift()
    }

    fire() {
        var shot = _cylinder[0]
        rshift()
        return shot
    }

    method(s) {
        unload()
        for (c in s) {
            if (c == "L") {
                load()
            } else if (c == "S") {
                spin()
            } else if (c == "F") {
                if (fire()) return 1
            }
        }
        return 0
    }

    static mstring(s) {
        var l = []
        for (c in s) {
            if (c == "L") {
                l.add("load")
            } else if (c == "S") {
                l.add("spin")
            } else if (c == "F") {
                l.add("fire")
            }
        }
        return l.join(", ")
    }
}

var rev = Revolver.new()
var tests = 100000
for (m in ["LSLSFSF", "LSLSFF", "LLSFSF", "LLSFF"]) {
    var sum = 0
    for (t in 1..tests) sum = sum + rev.method(m)
    Fmt.print("$-40s produces $6.3f\% deaths.", Revolver.mstring(m), sum * 100 / tests)
}
