import "./big" for BigInt

class Montgomery {
    static base { 2 }

    construct new(m) {
        if (m <= BigInt.zero || !m.testBit(0)) {
            Fiber.abort("Argument must be a positive, odd big integer.")
        }
        _m = m
        _n = m.bitLength.toSmall
        _rrm = (BigInt.one << (n*2)) % m
    }

    m   { _m }
    n   { _n }
    rrm { _rrm }

    reduce(t) {
        var a = t.copy()
        for (i in 0..._n) {
            if (a.testBit(0)) a = a + _m
            a = a >> 1
        }
        if (a >= _m) a = a - _m
        return a
     }
}

var m  = BigInt.new("750791094644726559640638407699")
var x1 = BigInt.new("540019781128412936473322405310")
var x2 = BigInt.new("515692107665463680305819378593")

var mont = Montgomery.new(m)
var t1 = x1 * mont.rrm
var t2 = x2 * mont.rrm

var r1 = mont.reduce(t1)
var r2 = mont.reduce(t2)
var r  = BigInt.one << (mont.n)

System.print("b :  %(Montgomery.base)")
System.print("n :  %(mont.n)")
System.print("r :  %(r)")
System.print("m :  %(mont.m)")
System.print("t1:  %(t1)")
System.print("t2:  %(t2)")
System.print("r1:  %(r1)")
System.print("r2:  %(r2)")
System.print()
System.print("Original x1       : %(x1)")
System.print("Recovered from r1 : %(mont.reduce(r1))")
System.print("Original x2       : %(x2)")
System.print("Recovered from r2 : %(mont.reduce(r2))")

System.print("\nMontgomery computation of x1 ^ x2 mod m :")
var prod = mont.reduce(mont.rrm)
var base = mont.reduce(x1 * mont.rrm)
var exp  = x2
while (exp.bitLength > 0) {
    if (exp.testBit(0)) prod = mont.reduce(prod * base)
    exp = exp >> 1
    base = mont.reduce(base * base)
}
System.print(mont.reduce(prod))
System.print("\nLibrary-based computation of x1 ^ x2 mod m :")
System.print(x1.modPow(x2, m))
