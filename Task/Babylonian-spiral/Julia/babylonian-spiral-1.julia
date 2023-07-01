""" Rosetta Code task rosettacode.org/wiki/Babylonian_spiral """

using GLMakie

const squarecache = Int[]

"""
Get the points for a Babylonian spiral of `nsteps` steps. Origin is at (0, 0)
with first step one unit in the positive direction along the vertical (y) axis.
See also: oeis.org/A256111, oeis.org/A297346, oeis.org/A297347
"""
function babylonianspiral(nsteps)
    if length(squarecache) <= nsteps
        append!(squarecache, map(x -> x * x, length(squarecache):nsteps))
    end
    # first line segment is 1 unit in vertical direction, with y vertical, x horizontal
    xydeltas, δ² = [(0, 0), (0, 1)], 1
    for _ in 1:nsteps-2
        x, y = xydeltas[end]
        θ = atan(y, x)
        candidates = Tuple{Int64,Int64}[]
        while isempty(candidates)
            δ² += 1
            for (k, a) in enumerate(squarecache)
                a > δ² ÷ 2 && break
                for j in isqrt(δ²)+1:-1:1
                    b = squarecache[j+1]
                    a + b < δ² && break
                    if a + b == δ²
                        i = k - 1
                        push!(
                            candidates,
                            (i, j),
                            (-i, j),
                            (i, -j),
                            (-i, -j),
                            (j, i),
                            (-j, i),
                            (j, -i),
                            (-j, -i),
                        )
                    end
                end
            end
        end
        _, idx = findmin(p -> mod1(θ - atan(p[2], p[1]), 2π), candidates)
        push!(xydeltas, candidates[idx])
    end
    return accumulate((a, b) -> (a[1] + b[1], a[2] + b[2]), xydeltas)
end

println("The first 40 Babylonian spiral points are:")
for (i, p) in enumerate(babylonianspiral(40))
    print(rpad(p, 10), i % 10 == 0 ? "\n" : "")
end

lines(babylonianspiral(10_000), linewidth = 1)
