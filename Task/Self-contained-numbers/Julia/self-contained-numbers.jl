function isselfcontained(n::Integer)
    m = n
    while m > 1
        m = iseven(m) ? m >> 1 : m * 3 + 1
        if m % n == 0
            return true
        end
    end
    return false
end

result = Iterators.take(Iterators.filter(isselfcontained, Iterators.countfrom(1, 2)), 7)
println(collect(result))
