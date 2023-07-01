using Printf, DataStructures, IterTools

function findtaxinumbers(nmax::Integer)
    cube2n = Dict{Int,Int}(x ^ 3 => x for x in 0:nmax)
    sum2cubes = DefaultDict{Int,Set{NTuple{2,Int}}}(Set{NTuple{2,Int}})
    for ((c1, _), (c2, _)) in product(cube2n, cube2n)
        if c1 ≥ c2
            push!(sum2cubes[c1 + c2], (cube2n[c1], cube2n[c2]))
        end
    end

    taxied = collect((k, v) for (k, v) in sum2cubes if length(v) ≥ 2)
    return sort!(taxied, by = first)
end
taxied = findtaxinumbers(1200)

for (ith, (cube, set)) in zip(1:25, taxied[1:25])
    @printf "%2i: %7i = %s\n" ith cube join(set, ", ")
    # println(ith, ": ", cube, " = ", join(set, ", "))
end
println("...")
for (ith, (cube, set)) in zip(2000:2006, taxied[2000:2006])
    @printf "%-4i: %i = %s\n" ith cube join(set, ", ")
end

# version 2
function findtaxinumbers(nmax::Integer)
    cubes, crev = collect(x ^ 3 for x in 1:nmax), Dict{Int,Int}()
    for (x, x3) in enumerate(cubes)
        crev[x3] = x
    end
    sums = collect(x + y for x in cubes for y in cubes if y < x)
    sort!(sums)

    idx = 0
    for i in 2:(endof(sums) - 1)
        if sums[i-1] != sums[i] && sums[i] == sums[i+1]
            idx += 1
            if 25 < idx < 2000 || idx > 2006 continue end
            n, p = sums[i], NTuple{2,Int}[]
            for x in cubes
                n < 2x && break
                if haskey(crev, n - x)
                    push!(p, (crev[x], crev[n - x]))
                end
            end
            @printf "%4d: %10d" idx n
            for x in p @printf(" = %4d ^ 3 + %4d ^ 3", x...) end
            println()
        end
    end
end

findtaxinumbers(1200)
