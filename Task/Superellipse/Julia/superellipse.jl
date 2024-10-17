function superellipse(n, a, b, step::Int=100)
    @assert n > 0 && a > 0 && b > 0
    na = 2 / n
    pc = 2π / step
    t  = 0
    xp = Vector{Float64}(undef, step + 1)
    yp = Vector{Float64}(undef, step + 1)
    for i in 0:step
        # because sin^n(x) is mathematically the same as (sin(x))^n...
        xp[i+1] = abs((cos(t))) ^ na * a * sign(cos(t))
        yp[i+1] = abs((sin(t))) ^ na * b * sign(sin(t))
        t += pc
    end
    return xp, yp
end

using UnicodePlots

x, y = superellipse(2.5, 200, 200)
println(lineplot(x, y))
