// Semi-abstract though we can define a 'pow' method in terms of the other operations.
class Ring {
    +(other) {}
    *(other) {}
    one      {}

    pow(p) {
        if (p.type != Num || !p.isInteger || p < 0) {
            Fiber.abort("Argument must be non-negative integer.")
        }
        var pwr = one
        while (p > 0) {
            pwr = pwr * this
            p = p - 1
        }
        return pwr
    }
}

class ModInt is Ring {
    construct new(value, modulo) {
        _value = value
        _modulo = modulo
    }

    value  { _value }
    modulo { _modulo }

    +(other) {
        if (other.type != ModInt || _modulo != other.modulo) {
            Fiber.abort("Argument must be a ModInt with the same modulus.")
        }
        return ModInt.new((_value + other.value) % _modulo, _modulo)
    }

    *(other) {
        if (other.type != ModInt || _modulo != other.modulo) {
            Fiber.abort("Argument must be a ModInt with the same modulus.")
        }
        return ModInt.new((_value * other.value) % _modulo, _modulo)
    }

    one { ModInt.new(1, _modulo) }

    toString { "Modint(%(_value), %(_modulo))" }
}

var f = Fn.new { |x|
    if (!(x is Ring)) Fiber.abort("Argument must be a Ring.")
    return x.pow(100) + x + x.one
}

var x = ModInt.new(10, 13)
System.print("x^100 + x + 1 for x = %(x) is %(f.call(x))")
