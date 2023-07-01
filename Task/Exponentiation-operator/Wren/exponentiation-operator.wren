class Num2 {
    static ipow(i, exp) {
        if (!i.isInteger) Fiber.abort("ipow method must have an integer receiver")
        if (!exp.isInteger) Fiber.abort("ipow method must have an integer exponent")
        if (i == 1 || exp == 0) return 1
        if (i == -1) return (exp%2 == 0) ? 1 : -1
        if (exp < 0) Fiber.abort("ipow method cannot have a negative exponent")
        var ans = 1
        var base = i
        var e = exp
        while (e > 1) {
            if (e%2 == 1) ans = ans * base
            e = (e/2).floor
            base = base * base
        }
        return ans * base
    }

    static fpow(f, exp) {
        if (!exp.isInteger) Fiber.abort("fpow method must have an integer exponent")
        var ans = 1.0
        var e = exp
        var base = (e < 0) ? 1/f : f
        if (e < 0) e = -e
        while (e > 0) {
            if (e%2 == 1) ans = ans * base
            e = (e/2).floor
            base = base * base
        }
        return ans
    }

    construct new(n) { _n = n }

    ^(exp) {
        if (_n.isInteger && (exp >= 0 || _n.abs == 1)) return Num2.ipow(_n, exp)
        return Num2.fpow(_n, exp)
    }
}

System.print("Using static methods:")
System.print("  2  ^  3   = %(Num2.ipow(2, 3))")
System.print("  1  ^ -10  = %(Num2.ipow(1, -10))")
System.print(" -1  ^ -3   = %(Num2.ipow(-1, -3))")
System.print()
System.print("  2.0 ^ -3  = %(Num2.fpow(2.0, -3))")
System.print("  1.5 ^  0  = %(Num2.fpow(1.5, 0))")
System.print("  4.5 ^  2  = %(Num2.fpow(4.5, 2))")

System.print("\nUsing the ^ operator:")
System.print("  2  ^  3   = %(Num2.new(2) ^ 3)")
System.print("  1  ^ -10  = %(Num2.new(1) ^ -10)")
System.print(" -1  ^ -3   = %(Num2.new(-1) ^ -3)")
System.print()
System.print("  2.0 ^ -3  = %(Num2.new(2.0) ^ -3)")
System.print("  1.5 ^  0  = %(Num2.new(1.5) ^ 0)")
System.print("  4.5 ^  2  = %(Num2.new(4.5) ^ 2)")
