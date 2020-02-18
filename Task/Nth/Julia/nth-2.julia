function ordinal(n::Integer)
    n < 0 && throw(DomainError())
    suffixes = ("st", "nd", "rd")
    u = n % 10
    t = n ÷ 10 % 10
    if u > 3 || u == 0 || t == 1
        suf = "th"
    else
        suf = suffixes[u]
    end
    return string(n, suf)
end
