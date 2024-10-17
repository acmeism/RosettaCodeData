using Primes

function ismagnanimous(n)
    n < 10 && return true
    for i in 1:ndigits(n)-1
        q, r = divrem(n, 10^i)
        !isprime(q + r) && return false
    end
    return true
end

function magnanimous(N)
    mvec, i = Int[], 0
    while length(mvec) < N
        if ismagnanimous(i)
            push!(mvec, i)
        end
        i += 1
    end
    return mvec
end

const mag400 = magnanimous(400)
println("First 45 magnanimous numbers:\n", mag400[1:24], "\n", mag400[25:45])
println("\n241st through 250th magnanimous numbers:\n", mag400[241:250])
println("\n391st through 400th magnanimous numbers:\n", mag400[391:400])
