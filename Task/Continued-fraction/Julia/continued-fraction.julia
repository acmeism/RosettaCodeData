function _sqrt(a::Bool, n)
    if a
        return n > 0 ? 2.0 : 1.0
    else
        return 1.0
    end
end

function _napier(a::Bool, n)
    if a
        return n > 0 ? Float64(n) : 2.0
    else
        return n > 1 ? n - 1.0 : 1.0
    end
end

function _pi(a::Bool, n)
    if a
        return n > 0 ? 6.0 : 3.0
    else
        return (2.0 * n - 1.0) ^ 2.0 # exponentiation operator
    end
end

function calc(f::Function, expansions::Integer)
    a, b = true, false
    r = 0.0
    for i in expansions:-1:1
        r = f(b, i) / (f(a, i) + r)
    end
    return f(a, 0) + r
end

for (v, f) in (("√2", _sqrt), ("e", _napier), ("π", _pi))
    @printf("%3s = %f\n", v, calc(f, 1000))
end
