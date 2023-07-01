using Primes

const pisanos = Dict{Int, Int}()
function pisano(p)
    p < 2 && return 1
    (i = get(pisanos, p, 0)) > 0 && return i
    lastn, n = 0, 1
    for i in 1:p^2
        lastn, n = n, (lastn + n) % p
        if lastn == 0 && n == 1
            pisanos[p] = i
            return i
        end
    end
    return 1
end

pisanoprime(p, k) = (@assert(isprime(p)); p^(k-1) * pisano(p))
pisanotask(n) = mapreduce(p -> pisanoprime(p[1], p[2]), lcm, collect(factor(n)), init=1)

for i in 1:15
    if isprime(i)
        println("pisanoPrime($i, 2) = ", pisanoprime(i, 2))
    end
end

for i in 1:180
    if isprime(i)
        println("pisanoPrime($i, 1) = ", pisanoprime(i, 1))
    end
end

println("\nPisano(n) for n from 2 to 180:\n", [pisano(i) for i in 2:180])
println("\nPisano(n) using pisanoPrime for n from 2 to 180:\n", [pisanotask(i) for i in 2:180])
