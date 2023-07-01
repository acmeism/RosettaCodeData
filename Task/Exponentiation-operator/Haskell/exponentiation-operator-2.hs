(^^) :: (Fractional a, Integral b) => a -> b -> a
x ^^ n = if n >= 0 then x^n else recip (x^(negate n))
