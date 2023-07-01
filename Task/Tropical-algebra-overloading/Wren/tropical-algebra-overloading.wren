var MinusInf = -1/0

class MaxTropical {
    construct new(r) {
        if (r.type != Num || r == 1/0 || r == 0/0) {
            Fiber.abort("Argument must be a real number or negative infinity.")
        }
        _r = r
    }

    r { _r }

    ==(other) {
        if (other.type != MaxTropical) Fiber.abort("Argument must be a MaxTropical object.")
        return _r == other.r
    }

    // equivalent to ⊕ operator
    +(other) {
        if (other.type != MaxTropical) Fiber.abort("Argument must be a MaxTropical object.")
        if (_r == MinusInf) return other
        if (other.r == MinusInf) return this
        return MaxTropical.new(_r.max(other.r))
    }

    // equivalent to ⊗ operator
    *(other) {
        if (other.type != MaxTropical) Fiber.abort("Argument must be a MaxTropical object.")
        if (_r == 0) return other
        if (other.r == 0) return this
        return MaxTropical.new(_r + other.r)
    }

    // exponentiation operator
    ^(e) {
        if (e.type != Num || !e.isInteger || e < 1) {
            Fiber.abort("Argument must be a positive integer.")
        }
        if (e == 1) return this
        var pow = MaxTropical.new(_r)
        for (i in 2..e) pow = pow * this
        return pow
    }

    toString { _r.toString }
}

var data = [
    [2, -2, "⊗"],
    [-0.001, MinusInf, "⊕"],
    [0, MinusInf, "⊗"],
    [1.5, -1, "⊕"],
    [-0.5, 0, "⊗"]
]
for (d in data) {
    var a = MaxTropical.new(d[0])
    var b = MaxTropical.new(d[1])
    if (d[2] == "⊕") {
        System.print("%(a) ⊕ %(b) = %(a + b)")
    } else {
        System.print("%(a) ⊗ %(b) = %(a * b)")
    }
}

var c = MaxTropical.new(5)
System.print("%(c) ^ 7 = %(c ^ 7)")

var d = MaxTropical.new(8)
var e = MaxTropical.new(7)
var f = c * (d + e)
var g = c * d + c * e
System.print("%(c) ⊗ (%(d) ⊕ %(e)) = %(f)")
System.print("%(c) ⊗ %(d) ⊕ %(c) ⊗ %(e) = %(g)")
System.print("%(c) ⊗ (%(d) ⊕ %(e)) == %(c) ⊗ %(d) ⊕ %(c) ⊗ %(e) is %(f == g)")
