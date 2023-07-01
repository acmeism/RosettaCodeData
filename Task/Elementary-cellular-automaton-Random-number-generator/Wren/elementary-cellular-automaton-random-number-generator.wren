import "/big" for BigInt

var n = 64

var pow2 = Fn.new { |x| BigInt.one << x }

var evolve = Fn.new { |state, rule|
    for (p in 0..9) {
        var b = BigInt.zero
        for (q in 7..0) {
            var st = state.copy()
            b = b | ((st & 1) << q)
            state = BigInt.zero
            for (i in 0...n) {
                var t1 = (i > 0) ? st >> (i-1) : st >> 63
                var t2 = (i == 0) ? st << 1 : (i == 1) ? st << 63 : st << (n+1-i)
                var t3 = (t1 | t2) & 7
                if ((pow2.call(t3) & rule) != BigInt.zero) state = state | pow2.call(i)
            }
        }
        System.write(" %(b)")
    }
    System.print()
}

evolve.call(BigInt.one, 30)
