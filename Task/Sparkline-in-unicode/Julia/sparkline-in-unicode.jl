function sparklineit(arr)
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

lines = strip.(split("""
    1 2 3 4 5 6 7 8 7 6 5 4 3 2 1
    1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5""", "\n"))
arrays = map(lin -> split(lin, r"\s+|\s*,\s*") .|> s -> parse(Float64, s), lines)
foreach(v -> println("$v → ", sparklineit(v)), arrays)
