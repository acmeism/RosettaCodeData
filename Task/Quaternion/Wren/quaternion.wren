class Quaternion {
    construct new(a, b, c, d ) {
        _a = a
        _b = b
        _c = c
        _d = d
    }

    a { _a }
    b { _b }
    c { _c }
    d { _d }

    norm { (a*a + b*b + c*c + d*d).sqrt }

    - { Quaternion.new(-a, -b, -c, -d) }

    conj { Quaternion.new(a, -b, -c, -d) }

    + (q) {
        if (q is Num) return Quaternion.new(a + q, b, c, d)
        return Quaternion.new(a + q.a, b + q.b, c + q.c, d + q.d)
    }

    * (q) {
        if (q is Num) return Quaternion.new(a * q, b * q, c * q, d * q)
        return Quaternion.new(a*q.a - b*q.b - c*q.c - d*q.d,
                              a*q.b + b*q.a + c*q.d - d*q.c,
                              a*q.c - b*q.d + c*q.a + d*q.b,
                              a*q.d + b*q.c - c*q.b + d*q.a)
    }

    == (q) { a == q.a && b == q.b && c == q.c && d == q.d }
    != (q) { !(this == q) }

    toString { "(%(a), %(b), %(c), %(d))" }

    static realAdd(r, q) { q + r }

    static realMul(r, q) { q * r }
}

var q  = Quaternion.new(1, 2, 3, 4)
var q1 = Quaternion.new(2, 3, 4, 5)
var q2 = Quaternion.new(3, 4, 5, 6)
var q3 = q1 * q2
var q4 = q2 * q1
var r = 7

System.print("q           = %(q)")
System.print("q1          = %(q1)")
System.print("q2          = %(q2)")
System.print("r           = %(r)")
System.print("norm(q)     = %(q.norm)")
System.print("-q          = %(-q)")
System.print("conj(q)     = %(q.conj)")
System.print("r + q       = %(Quaternion.realAdd(r, q))")
System.print("q + r       = %(q + r))")
System.print("q1 + q2     = %(q1 + q2)")
System.print("q2 + q1     = %(q2 + q1)")
System.print("rq          = %(Quaternion.realMul(r, q))")
System.print("qr          = %(q * r)")
System.print("q1q2        = %(q3)")
System.print("q2q1        = %(q4)")
System.print("q1q2 ≠ q2q1 = %(q3 != q4)")
