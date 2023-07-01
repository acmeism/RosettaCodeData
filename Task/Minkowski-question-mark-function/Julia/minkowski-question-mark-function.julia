function questionmark(x)
    y, p = fldmod(x, 1)
    q, d = 1 - p, .5
    while y + d > y
        p < q ? (q -= p) : (p -= q; y += d)
        d /= 2
    end
    y
end

function questionmark_inv(x)
    y, bits = fldmod(x, 1)
    lo, hi = [0, 1], [1, 1]
    while (y + /(lo...)) < (y + /(hi...))
        bit, bits = fldmod(2bits, 1)
        bit > 0 ? (lo .+= hi) : (hi .+= lo)
    end
    y + /(lo...)
end

x, y = 0.7182818281828, 0.1213141516171819
for (a, b) ∈ [
        (5/3, questionmark((1 + √5)/2)),
        ((√13-7)/6, questionmark_inv(-5/9)),
        (x, questionmark_inv(questionmark(x))),
        (y, questionmark(questionmark_inv(y)))]
    println(a, a ≈ b ? " ≈ " : " != ", b)
end
