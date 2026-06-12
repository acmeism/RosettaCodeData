function iroot(a, b)
    b < 2 && return b
    a1, c = a - 1, 1
    d = (a1 * c + b ÷ c^a1) ÷ a
    e = (a1 * d + b ÷ d^a1) ÷ a
    while d ≠ c ≠ e
        c, d, e = d, e, (a1 * e + b ÷ (e ^ a1)) ÷ a
    end

    min(d, e)
end

println("First 2,001 digits of the square root of two:\n", iroot(2, 2 * big(100) ^ 2000))
