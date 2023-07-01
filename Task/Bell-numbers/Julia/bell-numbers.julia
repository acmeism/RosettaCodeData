"""
    bellnum(n)
Compute the ``n``th Bell number.
"""
function bellnum(n::Integer)
    if n < 0
        throw(DomainError(n))
    elseif n < 2
        return 1
    end
    list = Vector{BigInt}(undef, n)
    list[1] = 1
    for i = 2:n
        for j = 1:i - 2
            list[i - j - 1] += list[i - j]
        end
        list[i] = list[1] + list[i - 1]
    end
    return list[n]
end

for i in 1:50
    println(bellnum(i))
end
