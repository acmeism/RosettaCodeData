function uniquein(a)
    counts = Dict{Char, Int}()
    for c in prod(list)
        counts[c] = get!(counts, c, 0) + 1
    end
    return sort([c for (c, n) in counts if n == 1])
end

println(uniquein(list))

using BenchmarkTools
@btime is_once_per_all_strings_in(list)
@btime uniquein(list)
