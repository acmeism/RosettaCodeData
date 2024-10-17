using Combinatorics, StatsBase

namesofline(n) = counts([x[1] for x in integer_partitions(n)])

function centerjustpyramid(n)
    maxwidth = length(string(namesofline(n)))
    for i in 1:n
        s = string(namesofline(i))
        println(" " ^ div(maxwidth - length(s), 2), s)
    end
end

centerjustpyramid(25)

const cachecountpartitions = Dict{BigInt,BigInt}()
function countpartitions(n::BigInt)
    if n < 0
        0
    elseif n < 2
        1
    elseif (np = get(cachecountpartitions, n, 0)) > 0
        np
    else
        np = 0
        sgn = 1
        for k = 1:n
            np += sgn * (countpartitions(n - (k*(3k-1)) >> 1) + countpartitions(n - (k*(3k+1)) >> 1))
            sgn = -sgn
        end
        cachecountpartitions[n] = np
    end
end

G(n) = countpartitions(BigInt(n))

for g in [23, 123, 1234, 12345]
    @time println("\nG($g) is $(G(g))")
end
