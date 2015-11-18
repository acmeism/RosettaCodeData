function polycoefs(n::Int64)
    pc = typeof(n)[]
    if n < 0
        return pc
    end
    sgn = one(n)
    for k in n:-1:0
        push!(pc, sgn*binomial(n, k))
        sgn = -sgn
    end
    return pc
end
