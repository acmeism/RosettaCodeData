/* Safe_addition.wren */
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

    static stepAway(x) { new(nextAfter_(x, -1/0), nextAfter_(x, 1/0)) }

    static safeAdd(x, y) { stepAway(x + y) }

    foreign static nextAfter_(x, y) // the code for this is written in C

    toString { "[%(_lower), %(_upper)]" }
}

var a = 1.2
var b = 0.03
System.print("(%(a) + %(b)) is in the range %(Interval.safeAdd(a,b))")
