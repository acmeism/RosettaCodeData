import "/fmt" for Fmt

class Maybe {
    construct new(value) {
        _value = value
    }

    value { _value }

    bind(f) { f.call(_value) }

    static unit(i) { Maybe.new(i) }
}

var decrement = Fn.new { |i|
    if (!i) return Maybe.unit(null)
    return Maybe.unit(i - 1)
}

var triple = Fn.new { |i|
    if (!i) return Maybe.unit(null)
    return Maybe.unit(3 * i)
}

for (i in [3, 4, null, 5]) {
    var m1 = Maybe.unit(i)
    var m2 = m1.bind(decrement).bind(triple)
    var s1 = (m1.value) ? "%(m1.value)" : "none"
    var s2 = (m2.value) ? "%(m2.value)" : "none"
    System.print("%(Fmt.s(4, s1)) -> %(s2)")
}
