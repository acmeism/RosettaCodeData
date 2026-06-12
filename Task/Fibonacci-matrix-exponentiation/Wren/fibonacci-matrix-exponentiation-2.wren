import "./big" for BigInt
import "./fmt" for Fmt

var lucas = Fn.new { |n|
    var inner  // recursive function
    inner = Fn.new { |n|
        if (n == BigInt.zero) return [BigInt.zero, BigInt.one]
        var t = n >> 1
        var res = inner.call(t)
        var u = res[0]
        var v = res[1]
        t = n & BigInt.two
        var q = t - BigInt.one
        var r = BigInt.zero
        u = u.square
        v = v.square
        t = n & BigInt.one
        if (t == BigInt.one) {
            t = u - q
            t = BigInt.two * t
            r = BigInt.three * v
            return [u + v, r - t]
        } else {
            t = BigInt.three * u
            r = v + q
            r = BigInt.two * r
            return [r - t, u + v]
        }
    }
    var t = n >> 1
    var res = inner.call(t)
    var u = res[0]
    var v = res[1]
    var l = BigInt.two * v
    l = l - u  // Lucas function
    t = n & BigInt.one
    if (t == BigInt.one) {
        var q = n & BigInt.two
        q = q - BigInt.one
        t = v * l
        return t + q
    }
    return u * l
}

var n = BigInt.zero
var i = 10
while (i <= 1e7) {
    n = BigInt.new(i)
    var s = lucas.call(n).toString
    Fmt.print("The digits of the $,sth Fibonacci number ($,s) are:", i, s.count)
    if (s.count > 20) {
        Fmt.print("  First 20 : $s", s[0...20])
        if (s.count < 40) {
            Fmt.print("  Final $-2d : $s", s.count-20, s[20..-1])
        } else {
            Fmt.print("  Final 20 : $s", s[s.count-20..-1])
        }
    } else {
        Fmt.print("  All $-2d   : $s", s.count, s)
    }
    System.print()
    i = i * 10
}
n = BigInt.one << 16
var s = lucas.call(n).toString
Fmt.print("The digits of the 2^16th Fibonacci number ($,s) are:", s.count)
Fmt.print("  First 20 : $s", s[0...20])
Fmt.print("  Final 20 : $s", s[s.count-20..-1])
