import "/dynamic" for Struct

// constants
var EMX  = 64       // exponent maximum (if indexing starts at -EMX)
var DMX  = 1e5      // approximation loop maximum
var AMX  = 1048576  // argument maximum
var PMAX = 32749    // prime maximum

// global variables
var P1 = 0
var P  = 7    // default prime
var K  = 11   // precision

var Ratio = Struct.create("Ratio", ["a", "b"])

class Padic {
    // uninitialized
    construct new() {
        _v = 0
        _d = List.filled(2 * EMX, 0) // add EMX to index to be consistent wih FB
    }

    // properties
    v { _v }
    v=(o) { _v = o }
    d { _d }

    // (re)initialize 'this' from Ratio, set 'sw' to print
    r2pa(q, sw) {
        var a = q.a
        var b = q.b
        if (b == 0) return 1
        if (b < 0) {
            b = -b
            a = -a
        }
        if (a.abs > AMX || b > AMX) return -1
        if (P < 2 || K < 1) return 1
        P = P.min(PMAX)  // maximum short prime
        K = K.min(EMX-1) // maximum array length
        if (sw != 0) {
            System.write("%(a)/%(b) + ")  // numerator, denominator
            System.print("0(%(P)^%(K))")   // prime, precision
        }

        // (re)initialize
        _v = 0
        P1 = P - 1
        _d = List.filled(2 * EMX, 0)
        if (a == 0) return 0
        var i = 0
        // find -exponent of P in b
        while (b%P == 0) {
            b = (b/P).truncate
            i = i - 1
        }
        var s = 0
        var r = b % P

        // modular inverse for small P
        var b1 = 1
        while (b1 <= P1) {
            s = s + r
            if (s > P1) s = s - P
            if (s == 1) break
            b1 = b1 + 1
        }
        if (b1 == P) {
            System.print("r2pa: impossible inverse mod")
            return -1
        }
        _v = EMX
        while (true) {
            // find exponent of P in a
            while (a%P == 0) {
                a = (a/P).truncate
                i = i + 1
            }

            // valuation
            if (_v == EMX) _v = i

            // upper bound
            if (i >= EMX) break

            // check precision
            if ((i - _v) > K) break

            // next digit
            _d[i+EMX] = a * b1 % P
            if (_d[i+EMX] < 0) _d[i+EMX] = _d[i+EMX] + P

            // remainder - digit * divisor
            a = a - _d[i+EMX]*b
            if (a == 0) break
        }
        return 0
    }

    // Horner's rule
    dsum() {
        var t = _v.min(0)
        var s = 0
        for (i in K - 1 + t..t) {
            var r = s
            s = s * P
            if (r != 0 && ((s/r).truncate - P) != 0) {
                // overflow
                s = -1
                break
            }
            s = s + _d[i+EMX]
        }
        return s
    }

    // rational reconstruction
    crat() {
        var fl = false
        var s = this
        var j = 0
        var i = 1

        // denominator count
        while (i <= DMX) {
            // check for integer
            j = K - 1 + _v
            while (j >= _v) {
                if (s.d[j+EMX] != 0) break
                j = j - 1
            }
            fl = ((j - _v) * 2) < K
            if (fl) {
                fl = false
                break
            }

            // check negative integer
            j = K - 1 + _v
            while (j >= _v) {
                if (P1 - s.d[j+EMX] != 0) break
                j = j - 1
            }
            fl = ((j - _v) * 2) < K
            if (fl) break

            // repeatedly add self to s
            s = s + this
            i = i + 1
        }
        if (fl) s = s.cmpt

        // numerator: weighted digit sum
        var x = s.dsum()
        var y = i
        if (x < 0 || y > DMX) {
            System.print("crat: fail")
        } else {
            // negative powers
            i = _v
            while (i <= -1) {
                y = y * P
                i = i + 1
            }

            // negative rational
            if (fl) x = -x
            System.write(x)
            if (y > 1) System.write("/%(y)")
            System.print()
        }
    }

    // print expansion
    printf(sw) {
        var t = _v.min(0)
        for (i in K - 1 + t..t) {
            System.write(_d[i + EMX])
            if (i == 0 && _v < 0) System.write(".")
            System.write(" ")
        }
        System.print()
        // rational approximation
        if (sw != 0) crat()
    }

    // add b to 'this'
    +(b) {
        var c = 0
        var r = Padic.new()
        r.v = _v.min(b.v)
        for (i in r.v..K + r.v) {
            c = c + _d[i+EMX] + b.d[i+EMX]
            if (c > P1) {
                r.d[i+EMX] = c - P
                c = 1
            } else {
                r.d[i+EMX] = c
                c = 0
            }
        }
        return r
    }

    // complement
    cmpt {
        var c = 1
        var r = Padic.new()
        r.v = _v
        for (i in _v..K + _v) {
            c = c + P1 - _d[i+EMX]
            if (c > P1) {
                r.d[i+EMX] = c - P
                c = 1
            } else {
                r.d[i+EMX] = c
                c = 0
            }
        }
        return r
    }
}

var data = [
    /* rational reconstruction depends on the precision
       until the dsum-loop overflows */
    [2, 1, 2, 4, 1, 1],
    [4, 1, 2, 4, 3, 1],
    [4, 1, 2, 5, 3, 1],
    [4, 9, 5, 4, 8, 9],
    [26, 25, 5, 4, -109, 125],
    [49, 2, 7, 6, -4851, 2],
    [-9, 5, 3, 8, 27, 7],
    [5, 19, 2, 12, -101, 384],
    /* two decadic pairs */
    [2, 7, 10, 7, -1, 7],
    [34, 21, 10, 9, -39034, 791],
    /* familiar digits */
    [11, 4, 2, 43, 679001, 207],
    [-8, 9, 23, 9, 302113, 92],
    [-22, 7, 3, 23, 46071, 379],
    [-22, 7, 32749, 3, 46071, 379],
    [35, 61, 5, 20, 9400, 109],
    [-101, 109, 61, 7, 583376, 6649],
    [-25, 26, 7, 13, 5571, 137],
    [1, 4, 7, 11, 9263, 2837],
    [122, 407, 7, 11, -517, 1477],
    /* more subtle */
    [5, 8, 7, 11, 353, 30809]
]

var sw = 0
var a = Padic.new()
var b = Padic.new()

for (d in data) {
    var q = Ratio.new(d[0], d[1])
    P = d[2]
    K = d[3]
    sw = a.r2pa(q, 1)
    if (sw == 1) break
    a.printf(0)
    q.a = d[4]
    q.b = d[5]
    sw = sw | b.r2pa(q, 1)
    if (sw == 1) break
    if (sw == 0) {
        b.printf(0)
        var c = a + b
        System.print("+ =")
        c.printf(1)
    }
    System.print()
}
