function sparklineit(arr::Vector{<:Integer})
    sparkchars = '\u2581':'\u2588'
    dyn = length(sparkchars)
    lo, hi = extrema(arr)
    b = @. max(ceil(Int, dyn * (arr - lo) / (hi - lo)), 1)
    return join(sparkchars[b])
end

v = rand(0:10, 10)
println("$v → ", sparklineit(v))
v = 10rand(10)
println("$(round.(v, 2)) → ", sparklineit(v))
