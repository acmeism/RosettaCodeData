function horner(coefs, x)
    s = coefs[end] * one(x)
    for k in length(coefs)-1:-1:1
        s = coefs[k] + x * s
    end
    return s
end

@show horner([-19, 7, -4, 6], 3)
