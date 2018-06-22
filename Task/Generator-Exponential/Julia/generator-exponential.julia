drop(gen::Function, n::Integer) = (for _ in 1:n gen() end; gen)
take(gen::Function, n::Integer) = collect(gen() for _ in 1:n)

function pgen(n::Number)
    x = 0
    return () -> (x += 1) ^ n
end

function genfilter(g1::Function, g2::Function)
    local r1
    local r2 = g2()
    return () -> begin
        r1 = g1()
        while r2 <  r1 r2 = g2() end
        while r1 == r2 r1 = g1() end
        return r1
    end
end

@show take(drop(genfilter(pgen(2), pgen(3)), 20), 10)
