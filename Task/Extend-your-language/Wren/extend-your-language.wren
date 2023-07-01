class IfBoth {
    construct new(cond1, cond2) {
        _cond1 = cond1
        _cond2 = cond2
    }

    elseFirst(func) {
        if (_cond1 && !_cond2) func.call()
        return this
    }

    elseSecond(func) {
        if (_cond2 && !_cond1) func.call()
        return this
    }

    elseNeither(func) {
        if (!_cond1 && !_cond2) func.call()
        return this // in case it's called out of order
    }
}

var ifBoth = Fn.new { |cond1, cond2, func|
    if (cond1 && cond2) func.call()
    return IfBoth.new(cond1, cond2)
}

var a = 0
var b = 1

ifBoth.call(a == 1, b == 3) {
    System.print("a == 1 and b == 3")
}.elseFirst {
    System.print("a == 1 and b <> 3")
}.elseSecond {
    System.print("a <> 1 and b = 3")
}.elseNeither {
    System.print("a <> 1 and b <> 3")
}

// It's also possible to omit any (or all) of the 'else' clauses
// or to call them out of order.
a = 1
b = 0

ifBoth.call (a == 1, b == 3) {
    System.print("a == 1 and b == 3")
}.elseNeither {
    System.print("a <> 1 and b <> 3")
}.elseFirst {
    System.print("a == 1 and b <> 3")
}
