function jarodistance(s1, s2)
    m = t = p = 0
    matchstd = max(length(s1), length(s2)) / 2 - 1
    for (i1, c1) in enumerate(s1)
        for (i2, c2) in enumerate(s2)
            (c1 == c2) && (abs(i2 - i1) ≤ matchstd) && (m += 1)
            (c1 == c2) && (i2 == i1) && (p += 1)
        end
    end
    t = (m - p) / 2
    1 / 3 * (m / length(s1) + m / length(s2) + (m - t) / m)
end

@show jarodistance("MARTHA", "MARHTA")
@show jarodistance("DIXON", "DICKSONX")
@show jarodistance("JELLYFISH", "SMELLYFISH")
