function ethmult(a::Integer, b::Integer)
    r = 0
    while a > 0
        r += b * !even(a)
        a = halve(a)
        b = double(b)
    end
    return r
end

@show ethmult(17, 34)
