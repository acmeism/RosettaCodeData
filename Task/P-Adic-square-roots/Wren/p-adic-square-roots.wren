import "./dynamic" for Struct
import "./big" for BigInt

// constants
var EMX  = 64       // exponent maximum (if indexing starts at -EMX)
var AMX  = 6000     // argument maximum
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

    // (re)initialize 'this' to the square root of a Ratio, set 'sw' to print
    sqrt(g, sw) {
        var a = g.a
        var b = g.b
        if (b == 0) return 1
        if (b < 0) {
            b = -b
            a = -a
        }
        if (P < 2 || K < 1) return 1
        P = P.min(PMAX)  // maximum short prime
        if (sw != 0) {
            System.write("%(a)/%(b) + ")  // numerator, denominator
            System.print("0(%(P)^%(K))")  // prime, precision
        }

        // (re)initialize
        _v = 0
        P1 = P - 1
        _d = List.filled(2 * EMX, 0)
        if (a == 0) return 0

        //valuation
        while (b%P== 0) {
            b = (b/P).truncate
            _v = _v - 1
        }

        while (a%P == 0) {
            a = (a/P).truncate
            _v = _v + 1
        }

        if ((_v & 1) == 1) {
            // odd valuation
            System.print("non-residue mod %(P)")
            return -1
        }
        K = (K + _v).min(EMX - 1) - _v  // maximum array length
        _v = (_v/2).truncate

        if (a.abs > AMX || b > AMX) return -1
        var bb = BigInt.new(b) // to avoid overflowing 'f(x) = b * x * x – a'
        var r
        var s
        var t
        var f
        var f1
        if (P == 2) {
            t = a * b
            if ((t & 7) - 1 != 0) {
                System.print("non-residue mod 8")
                return -1
            }
        } else {
            // find root for small P
            r = 1
            while (r <= P1) {
                f = bb * r * r - a
                if ((f % P) == 0) break
                r = r + 1
            }
            if (r == P) {
                System.print("non-residue mod %(P)")
                return -1
            }
            t = 2 * b * r
            s = 0
            t = t % P

            // modular inverse for small P
            f1 = 1
            while (f1 <= P1) {
                s = s + t
                if (s > P1) s = s - P
                if (s == 1) break
                f1 = f1 + 1
            }
            if (f1 == P) {
                System.print("impossible inverse mod")
                return -1
            }
        }
        var x
        var pk
        var q
        var i
        if (P == 2) {
            // initialize
            x = 1
            _d[_v+EMX] = 1
            _d[_v+1+EMX] = 0
            pk = 4
            i = _v + 2
            while (i <= K - 1 + _v) {
                pk = pk * 2
                f = bb * x * x - a
                q = f / pk
                // overflow
                if (f != q * pk) break
                // next digit
                _d[i+EMX] = ((q & 1) != 0) ? 1 : 0
                // lift x
                x = x + _d[i+EMX]*(pk >> 1)
                i = i + 1
            }

        } else {
            f1 = P - f1
            x = r
            _d[_v+EMX] = x
            pk = 1
            i = _v + 1
            while (i <= K - 1 + _v) {
                pk = pk * P
                f = bb * x * x - a
                q = f / pk
                // overflow
                if (f != q * pk) break
                _d[i+EMX] = q.toSmall * f1 % P
                if (_d[i+EMX] < 0) _d[i+EMX] = _d[i+EMX] + P
                x = x + _d[i+EMX]*pk
                i = i + 1
            }
        }
        K = i - _v
        if (sw != 0) System.print("lift: %(x) mod %(P)^%(K)")
        return 0
    }

    // rational reconstruction
    crat(sw) {
        var t = _v.min(0)
        // weighted digit sum
        var s = 0
        var pk = 1
        for (i in t..K-1+_v) {
            P1 = pk
            pk = pk * P
            if (((pk/P1).truncate - P) != 0) {
                // overflow
                pk = p1
                break
            }
            s = s + _d[i+EMX]*P1
        }

        // lattice basis reduction
        var m = [pk, s]
        var n = [0, 1]
        var i = 0
        var j = 1
        s = s * s + 1
        // Lagrange's algorithm
        while (true) {
            var f = (m[i] * m[j] + n[i] * n[j]) / s
            // Euclidean step
            var q = (f + 0.5).floor
            m[i] = m[i] - q*m[j]
            n[i] = n[i] - q*n[j]
            q = s
            s = m[i] * m[i] + n[i] * n[i]
            // compare norms
            if (s < q) {
                // interchange vectors
                var z = i
                i = j
                j = z
            } else {
                break
            }
        }
        var x = m[j]
        var y = n[j]
        if (y < 0) {
            y = -y
            x = -x
        }

        // check determinant
        t = (m[i]*y - x*n[i]).abs == pk
        if (!t) {
            System.print("crat: fail")
            x = 0
            y = 1
        } else {
            // negative powers
            var i = _v
            while (i <= -1) {
                y = y * P
                i = i + 1
            }
            if (sw != 0) {
                System.write(x)
                if (y > 1) System.write("/%(y)")
                System.print()
            }
        }

        return Ratio.new(x, y)
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
        if (sw != 0) crat(sw)
    }

    // complement
    cmpt {
        var c = 1
        var r = Padic.new()
        r.v = _v
        for (i in r.v..K + r.v) {
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

    // square
    sqr {
        var c = 0
        var r = Padic.new()
        r.v = _v * 2
        for (i in 0..K) {
            for (j in 0..i) c = c + _d[_v+j+EMX] * _d[_v+i-j+EMX]
            // Euclidean step
            var q = (c/P).truncate
            r.d[r.v+i+EMX] = c - q*P
            c = q
        }
        return r
    }
}

var data = [
    [-7, 1, 2, 7],
    [9, 1, 2, 8],
    [17, 1, 2, 9],
    [497, 10496, 2, 18],
    [10496, 497, 2, 19],
    [3141, 5926, 3, 15],
    [2718,  281, 3, 13],
    [-1,  1,  5, 8],
    [86, 25,  5, 8],
    [2150, 1,  5, 8],
    [2,1, 7, 8],
    [-2645, 28518, 7, 9],
    [3029, 4821, 7, 9],
    [379, 449, 7, 8],
    [717, 8, 11, 7],
    [1414, 213, 41, 5],
    [-255, 256, 257, 3]
]

var sw = 0
var a = Padic.new()
var c = Padic.new()

for (d in data) {
    var q = Ratio.new(d[0], d[1])
    P = d[2]
    K = d[3]
    sw = a.sqrt(q, 1)
    if (sw == 1) break
    if (sw == 0) {
        System.print("sqrt +/-")
        System.write("...")
        a.printf(0)
        a = a.cmpt
        System.write("...")
        a.printf(0)
        c = a.sqr
        System.print("sqrt^2")
        System.write("   ")
        c.printf(0)
        var r = c.crat(1)
        if (q.a * r.b - r.a * q.b != 0) {
            System.print("fail: sqrt^2")
        }
        System.print()
    }
}
