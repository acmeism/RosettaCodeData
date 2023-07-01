import "/dynamic" for Struct
import "/big" for BigInt
import "/fmt" for Fmt
import "/math" for Boolean
import "random" for Random

var rand = Random.new()

// rational ec point: x and y are BigInts
var Epnt = Struct.create("Epnt", ["x", "y"])

// elliptic curve parameters: N is a BigInt, G is an Epnt, rest are integral Nums
var Curve = Struct.create("Curve", ["a", "b", "N", "G", "r"])

// signature pair: a and b are integral Nums
var Pair = Struct.create("Pair", ["a", "b"])

// maximum modulus
var mxN = 1073741789

// max order G = mxN + 65536
var mxr = 1073807325

// symbolic infinity
var inf = BigInt.new(-2147483647)

// single global curve
var e = Curve.new(0, 0, BigInt.zero, Epnt.new(inf, BigInt.zero), 0)

// impossible inverse mod N
var inverr = false

// return mod(v^-1, u)
var exgcd = Fn.new { |v, u|
    var r = 0
    var s = 1
    if (v < 0) v = v + u
    while (v != 0) {
        var q = (u / v).truncate
        var t = u - q * v
        u = v
        v = t
        t = r - q * s
        r = s
        s = t
    }
    if (u != 1) {
        System.print(" impossible inverse mod N, gcd = %(u)")
        inverr = true
    }
    return r
}

// returns mod(a, N), a is a BigInt
var modn = Fn.new { |a|
    var b = a.copy()
    b = b % e.N
    if (b < 0) b = b + e.N
    return b
}

// returns mod(a, r), a is a BigInt
var modr = Fn.new { |a|
   var b = a.copy()
   b = b % e.r
   if (b < 0) b = b + e.r
   return b
}

// returns the discriminant of E
var disc = Fn.new {
    var a = BigInt.new(e.a)
    var b = BigInt.new(e.b)
    var c = modn.call(a * modn.call(a * a)) * 4
    return modn.call((c + modn.call(b * b) * 27) * (-16)).toSmall
}

// return true if P is 'zero' point (at inf, 0)
var isZero = Fn.new { |p| p.x == inf && p.y == 0 }

// return true if P is on curve E
var isOn = Fn.new { |p|
    var r = 0
    var s = 0
    if (!isZero.call(p)) {
        r = modn.call(p.x * modn.call(p.x * p.x + e.a) + e.b).toSmall
        s = modn.call(p.y * p.y).toSmall
    }
    return r == s
}

// full ec point addition
var padd = Fn.new { |p, q|
    var la = BigInt.zero
    var t  = BigInt.zero
    if (isZero.call(p)) return Epnt.new(q.x, q.y)
    if (isZero.call(q)) return Epnt.new(p.x, p.y)
    if (p.x != q.x) { // R = P + Q
        t = p.y - q.y
        la = modn.call(t * exgcd.call((p.x - q.x).toSmall, e.N.toSmall))
    } else { // P = Q, R = 2P
        if (p.y == q.y && p.y != 0) {
            t = modn.call(modn.call(p.x * p.x) * 3 + e.a)
            la = modn.call(t * exgcd.call((p.y * 2).toSmall, e.N.toSmall))
        } else {
            return Epnt.new(inf, BigInt.zero) // P = -Q, R = O
        }
    }
    if (inverr) return Epnt.new(inf, BigInt.zero)
    t = modn.call(la * la - p.x - q.x)
    return Epnt.new(t, modn.call(la * (p.x - t) - p.y))
}

// R = multiple kP
var pmul = Fn.new { |p, k|
    var s = Epnt.new(inf, BigInt.zero)
    var q = Epnt.new(p.x, p.y)
    while (k != 0) {
        if (k % 2 == 1) s = padd.call(s, q)
        if (inverr) {
            s.x = inf
            s.y = BigInt.zero
            break
        }
        q = padd.call(q, q)
        k = (k/2).floor
    }
    return s
}

// print point P with prefix f
var pprint = Fn.new { |f, p|
    var y = p.y
    if (isZero.call(p)) {
        Fmt.print("$s (0)", f)
    } else {
        if (y > e.N - y) y = y - e.N
        Fmt.print("$s ($i, $i)", f, p.x, y)
    }
}

// initialize elliptic curve
var ellinit = Fn.new { |i|
    var a  = BigInt.new(i[0])
    var b  = BigInt.new(i[1])
    e.N    = BigInt.new(i[2])
    inverr = false
    if (e.N < 5 || e.N > mxN) return false
    e.a = modn.call(a).toSmall
    e.b = modn.call(b).toSmall
    e.G.x = modn.call(BigInt.new(i[3]))
    e.G.y = modn.call(BigInt.new(i[4]))
    e.r = i[5]
    if (e.r < 5 || e.r > mxr) return false
    Fmt.write("\nE: y^2 = x^3 + $ix + $i", a, b)
    Fmt.print(" (mod $i)", e.N)
    pprint.call("base point G", e.G)
    Fmt.print("order(G, E) = $d", e.r)
    return true
}

// signature primitive
var signature = Fn.new { |s, f|
    var c
    var d
    var u
    var u1
    var sg = Pair.new(0, 0)
    var V
    System.print("\nsignature computation")
    while (true) {
        while (true) {
            u = 1 + (rand.float() * (e.r - 1)).truncate
            V = pmul.call(e.G, u)
            c = modr.call(V.x).toSmall
            if (c != 0) break
        }
        u1 = exgcd.call(u, e.r)
        d = modr.call((modr.call(s * c) + f) * u1).toSmall
        if (d != 0) break
    }
    Fmt.print("one-time u = $d", u)
    pprint.call("V = uG", V)
    sg.a = c
    sg.b = d
    return sg
}

// verification primitive
var verify = Fn.new { |W, f, sg|
    var c = sg.a
    var d = sg.b

    // domain check
    var t = (c > 0) && (c < e.r)
    t = Boolean.and(t, d > 0 && d < e.r)
    if (!t) return false
    System.print("\nsignature verification")
    var h = BigInt.new(exgcd.call(d, e.r))
    var h1 = modr.call(h * f).toSmall
    var h2 = modr.call(h * c).toSmall
    Fmt.print ("h1, h2 = $d, $d", h1, h2)
    var V = pmul.call(e.G, h1)
    var V2 = pmul.call(W, h2)
    pprint.call("h1G", V)
    pprint.call("h2W", V2)
    V = padd.call(V, V2)
    pprint.call("+ =", V)
    if (isZero.call(V)) return false
    var c1 = modr.call(V.x).toSmall
    Fmt.print("c' = $d", c1)
    return c1 == c
}

var errmsg = Fn.new {
    System.print("invalid parameter set")
    System.print("_____________________")
}

// digital signature on message hash f, error bit d
var ec_dsa = Fn.new { |f, d|
    // parameter check
    var t = disc.call() == 0
    t = Boolean.or(t, isZero.call(e.G))
    var W = pmul.call(e.G, e.r)
    t = Boolean.or(t, !isZero.call(W))
    t = Boolean.or(t, !isOn.call(e.G))
    if (t) {
        errmsg.call()
        return
    }
    System.print("\nkey generation")
    var s = 1 + (rand.float() * (e.r - 1)).truncate
    W = pmul.call(e.G, s)
    Fmt.print("private key s = $d\n", s)
    pprint.call("public key W = sG", W)

    // next highest power of 2 - 1
    t = e.r
    var i = 1
    while (i < 32) {
        t = t | (t >> i)
        i = i << 1
    }
    while (f > t) f = f >> 1
    Fmt.print("\naligned hash $x", f)
    var sg = signature.call(BigInt.new(s), f)
    if (inverr) {
        errmsg.call()
        return
    }
    Fmt.print("signature c, d = $d, $d", sg.a, sg.b)
    if (d > 0) {
        while (d > t) d = d >> 1
        f = f ^ d
        Fmt.print("\ncorrupted hash $x", f)
    }
    t = verify.call(W, f, sg)
    if (inverr) {
        errmsg.call()
        return
    }
    if (t) {
        System.print("Valid\n_____")
   } else {
        System.print("invalid\n_______")
   }
}

// Test vectors: elliptic curve domain parameters,
// short Weierstrass model y^2 = x^3 + ax + b (mod N)
var sets = [
   //    a,   b,  modulus N, base point G, order(G, E), cofactor
   [355, 671, 1073741789, 13693, 10088, 1073807281],
   [  0,   7,   67096021,  6580,   779,   16769911], // 4
   [ -3,   1,     877073,     0,     1,     878159],
   [  0,  14,      22651,    63,    30,        151], // 151
   [  3,   2,          5,     2,     1,          5],

   // ecdsa may fail if...
   // the base point is of composite order
   [  0,   7,   67096021,  2402,  6067,   33539822], // 2
   // the given order is a multiple of the true order
   [  0,   7,   67096021,  6580,   779,   67079644], // 1
   // the modulus is not prime (deceptive example)
   [  0,   7,     877069,     3, 97123,     877069],
   // fails if the modulus divides the discriminant
   [ 39, 387,      22651,    95,    27,      22651]
]
// Digital signature on message hash f,
// set d > 0 to simulate corrupted data
var f = 0x789abcde
var d = 0

for (s in sets) {
    if (ellinit.call(s)) {
        ec_dsa.call(f, d)
    } else {
        break
    }
}
