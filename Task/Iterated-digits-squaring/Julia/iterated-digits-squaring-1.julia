function iterate(m::Integer)
    while m != 1 && m != 89
        s = 0
        while m > 0 # compute sum of squares of digits
            m, d = divrem(m, 10)
            s += d ^ 2
        end
        m = s
    end
    return m
end
itercount(k::Integer) = count(x -> iterate(x) == 89, 1:k)
