import "numeric" for Float
import "io" for Stdfmt

class Interval {
    construct new(lower, upper) {
        if (lower.type != Num || upper.type != Num) {
            Fiber.abort("Arguments must be numbers.")
        }
        _lower = lower
        _upper = upper
    }

    lower { _lower }
    upper { _upper }

    static stepAway(x) { new(Float.prev(x), Float.next(x)) }

    static safeAdd(x, y) { stepAway(x + y) }

    toString {
        var ls = Stdfmt.writef("$f", _lower, null, 0, 16)
        var us = Stdfmt.writef("$f", _upper, null, 0, 16)
        return "[%(ls), %(us)]"
    }
}

var a = 1.2
var b = 0.03
System.print("(%(a) + %(b)) is in the range %(Interval.safeAdd(a,b))")
