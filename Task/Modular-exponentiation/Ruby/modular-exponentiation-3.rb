def mod_exp(n, e, mod)
    fail ArgumentError, 'negative exponent' if e < 0
    prod = 1
    base = n % mod
    until e.zero?
      prod = (prod * base) % mod if e.odd?
      e >>= 1
      base = (base * base) % mod
    end
    prod
  end
