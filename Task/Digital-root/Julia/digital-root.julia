function digitalroot(n::Integer, bs::Integer=10)
    if n < 0 || bs < 2 throw(DomainError()) end
    ds, pers = n, 0
    while bs ≤ ds
        ds = sum(digits(ds, bs))
        pers += 1
    end
    return pers, ds
end

for i in [627615, 39390, 588225, 393900588225, big(2) ^ 100]
    pers, ds = digitalroot(i)
    println(i, " has persistence ", pers, " and digital root ", ds)
end
