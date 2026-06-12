import "./fmt" for Fmt

var Y = Fn.new { |a|
    var ly = []
    for (x in a) {
        ly.add(Fn.new { |x| Fn.new { x.call(Y.call(a)) } }.call(x))
    }
    return ly
}

var evenOddFix = [
    Fn.new { |f| Fn.new { |n|
        if (n == 0) return true
        return f[1].call().call(n-1)
    }},

    Fn.new { |f| Fn.new { |n|
        if (n == 0) return false
        return f[0].call().call(n-1)
    }}
]

var collatzFix = [
    Fn.new { |f| Fn.new { |n, d|
        if (n == 1) return d
        return f[n%2 + 1].call().call(n, d+1)
    } },

    Fn.new { |f| Fn.new { |n, d| f[0].call().call((n/2).floor, d) } },

    Fn.new { |f| Fn.new { |n, d| f[0].call().call(3*n+1, d) } }
]

var evenOdd = Y.call(evenOddFix).map { |f| f.call() }.toList

var collatz = Y.call(collatzFix)[0].call()

for (x in 1..10) {
    var e = evenOdd[0].call(x)
    var o = evenOdd[1].call(x)
    var c = collatz.call(x, 0)
    Fmt.print("$2d: Even: $5s  Odd: $5s  Collatz: $n", x, e, o, c)
}
