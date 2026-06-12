class RE {
    // need to override if subtype has any fields
    == (other) { this.type == other.type }

    != (other) { !(this == other) }
}

class Empty is RE {
    construct new() {}

    toString { "0" }
}

var empty = Empty.new()

class Epsilon is RE {
    construct new() {}

    toString { "1" }
}

var epsilon = Epsilon.new()

class Car is RE {
    construct new(c) { _c = c }

    c { _c }

    toString { _c }

    == (other) { (other is Car) &&  _c == other.c }
}

class Union is RE {
    construct new(e, f) {
        _e = e
        _f = f
    }

    e { _e }
    f { _f }

    toString { "%(_e)+%(_f)" }

    == (other) { (other is Union) && _e == other.e && _f == other.f }
}

class Concat is RE {
    construct new(e, f) {
        _e = e
        _f = f
    }

    e { _e }
    f { _f }

    toString { "(%(_e))(%(_f))" }

    == (other) { (other is Concat) && _e == other.e && _f == other.f }
}

class Star is RE {
    construct new(e) { _e = e }

    e { _e }

    toString { "(%(_e))*" }

    == (other) { (other is Star) && _e == other.e }
}

var simpleRE = Fn.new { |e|
    var simple // recursive
    simple = Fn.new { |e|
        if (e is Union) {
            var ee = simple.call(e.e)
            var ef = simple.call(e.f)
            if (ee == ef) {
                return ee
            } else if (ee is Union) {
                return simple.call(Union.new(ee.e, Union.new(ee.f, ef)))
            } else if (ee == empty) {
                return ef
            } else if (ef == empty) {
                return ee
            } else {
                return Union.new(ee, ef)
            }
        } else if (e is Concat) {
            var ee = simple.call(e.e)
            var ef = simple.call(e.f)
            if (ee == epsilon) {
                return ef
            } else if (ef == epsilon) {
                return ee
            } else if (ee == empty || ef == empty) {
                return empty
            } else if (ee is Concat) {
                return simple.call(Concat.new(ee.e, Concat.new(ee.f, ef)))
            } else {
                return Concat.new(ee, ef)
            }
        } else if (e is Star) {
            var ee = simple.call(e.e)
            if ((ee is Empty) || (ee is Epsilon)) {
                return epsilon
            } else {
                return Star.new(ee)
            }
        } else {
            return e
        }
    }
    var prevE = null
    while (e != prevE) {
        prevE = e
        e = simple.call(e)
    }
    return e
}

var brzozowski = Fn.new { |a, b|
    var m = a.count
    for (n in m-1..0) {
        var ann = a[n][n]
        b[n] = Concat.new(Star.new(ann), b[n])
        for (j in 0...n) a[n][j] = Concat.new(Star.new(ann), a[n][j])
        for (i in 0...n) {
            b[i] = Union.new(b[i], Concat.new(a[i][n], b[n]))
            for (j in 0...n) {
                a[i][j] = Union.new(a[i][j], Concat.new(a[i][n], a[n][j]))
            }
        }
        for (i in 0...n) a[i][n] = empty
    }
    return b[0]
}

var a = [
    [empty, Car.new("a"), Car.new("b")],
    [Car.new("b"), empty, Car.new("a")],
    [Car.new("a"), Car.new("b"), empty]
]

var b = [epsilon, empty, empty]

var re = brzozowski.call(a, b)
System.print(re)
System.print("\nwhich simplifies to:\n")
System.print(simpleRE.call(re))
