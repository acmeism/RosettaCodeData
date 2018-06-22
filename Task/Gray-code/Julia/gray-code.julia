grayencode(n::Integer) = n ⊻ (n >> 1)
function graydecode(n::Integer)
    r = n
    while (n >>= 1) != 0
        r ⊻= n
    end
    return r
end
