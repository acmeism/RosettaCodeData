class TinyInt {
    construct new(n) {
        if (!(n is Num && n.isInteger && n >= 1 && n <= 10)) {
            Fiber.abort("Argument must be an integer between 1 and 10.")
        }
        _n = n
    }

    n { _n }

    +(other) { TinyInt.new(_n + other.n) }
    -(other) { TinyInt.new(_n - other.n) }
    *(other) { TinyInt.new(_n * other.n) }
    /(other) { TinyInt.new((_n / other.n).truncate) }

    ==(other) { _n == other.n }
    !=(other) { _n != other.n }

    toString { _n.toString }
}

var a = TinyInt.new(1)
var b = TinyInt.new(2)
var c = a + b
System.print("%(a) + %(b) = %(c)")
var d = c - a
System.print("%(c) - %(a) = %(d)")
var e = d / d
System.print("%(d) / %(d) = %(e)")
var f = c * c
System.print("%(c) * %(c) = %(f)")
System.print("%(a) != %(b) -> %(a != b)")
System.print("%(a) + %(a) == %(b) -> %((a + a) == b)")
var g = f + b // out of range error here
