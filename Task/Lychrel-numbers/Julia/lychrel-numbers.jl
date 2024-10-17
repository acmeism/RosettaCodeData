const cache = Dict{BigInt, Tuple{Bool, BigInt}}()

Base.reverse(n::Integer) = parse(BigInt, string(n) |> reverse)
function lychrel(n::BigInt)::Tuple{Bool, BigInt}
    if haskey(cache, n)
        return cache[n]
    end

    r = reverse(n)
    rst = (true, n)
    seen = Set{BigInt}()
    for i in 0:500
        n += r
        r = reverse(n)
        if n == r
            rst = (false, big(0))
            break
        end
        if haskey(cache, n)
            rst = cache[n]
            break
        end
        push!(seen, n)
    end

    for bi in seen
        cache[bi] = rst
    end
    return rst
end

seeds   = BigInt[]
related = BigInt[]
palin   = BigInt[]

for n in big.(1:10000)
    t = lychrel(n)
    if ! t[1]
        continue
    end
    if n == t[2]
        push!(seeds, n)
    else
        push!(related, n)
    end

    if n == t[2]
        push!(palin, t[2])
    end
end

println(length(seeds),   " lychrel seeds: ", join(seeds, ", "))
println(length(related), " lychrel related")
println(length(palin),   " lychrel palindromes: ", join(palin, ", "))
