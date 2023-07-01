import "/big" for BigRat
import "/fmt" for Fmt

/** represents a term of the form: c * atan(n / d) */
class Term {
    construct new(c, n, d) {
        _c = c
        _n = n
        _d = d
    }

    c { _c }
    n { _n }
    d { _d }

    toString {
        var a = "atan(%(n)/%(d))"
        return ((_c ==  1) ? " + " :
                (_c == -1) ? " - " :
                (_c <   0) ? " - %(-c)*" : " + %(c)*") + a
    }
}

var tanEval // recursive function
tanEval = Fn.new { |c, f|
    if (c == 1)  return f
    if (c < 0) return -tanEval.call(-c, f)
    var ca = (c/2).truncate
    var cb = c - ca
    var a = tanEval.call(ca, f)
    var b = tanEval.call(cb, f)
    return (a + b) / (BigRat.one - (a * b))
}

var tanSum // recursive function
tanSum = Fn.new { |terms|
    if (terms.count == 1) return tanEval.call(terms[0].c, BigRat.new(terms[0].n, terms[0].d))
    var half = (terms.count/2).floor
    var a = tanSum.call(terms.take(half).toList)
    var b = tanSum.call(terms.skip(half).toList)
    return (a + b) / (BigRat.one - (a * b))
}

var T = Term // type alias

var termsList = [
    [T.new(1, 1, 2), T.new(1, 1, 3)],
    [T.new(2, 1, 3), T.new(1, 1, 7)],
    [T.new(4, 1, 5), T.new(-1, 1, 239)],
    [T.new(5, 1, 7), T.new(2, 3, 79)],
    [T.new(5, 29, 278), T.new(7, 3, 79)],
    [T.new(1, 1, 2), T.new(1, 1, 5), T.new(1, 1, 8)],
    [T.new(4, 1, 5), T.new(-1, 1, 70), T.new(1, 1, 99)],
    [T.new(5, 1, 7), T.new(4, 1, 53), T.new(2, 1, 4443)],
    [T.new(6, 1, 8), T.new(2, 1, 57), T.new(1, 1, 239)],
    [T.new(8, 1, 10), T.new(-1, 1, 239), T.new(-4, 1, 515)],
    [T.new(12, 1, 18), T.new(8, 1, 57), T.new(-5, 1, 239)],
    [T.new(16, 1, 21), T.new(3, 1, 239), T.new(4, 3, 1042)],
    [T.new(22, 1, 28), T.new(2, 1, 443), T.new(-5, 1, 1393), T.new(-10, 1, 11018)],
    [T.new(22, 1, 38), T.new(17, 7, 601), T.new(10, 7, 8149)],
    [T.new(44, 1, 57), T.new(7, 1, 239), T.new(-12, 1, 682), T.new(24, 1, 12943)],
    [T.new(88, 1, 172), T.new(51, 1, 239), T.new(32, 1, 682), T.new(44, 1, 5357), T.new(68, 1, 12943)],
    [T.new(88, 1, 172), T.new(51, 1, 239), T.new(32, 1, 682), T.new(44, 1, 5357), T.new(68, 1, 12944)]
]

for (terms in termsList) {
    var f = Fmt.swrite("$-5s: 1 == tan(", tanSum.call(terms) == BigRat.one)
    System.write(f)
    System.write(terms[0].toString.skip(3).join())
    for (i in 1...terms.count) System.write(terms[i])
    System.print(")")
}
