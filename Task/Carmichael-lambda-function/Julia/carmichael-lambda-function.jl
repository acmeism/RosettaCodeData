using DelimitedFiles
using Primes

const maxcached = typemax(Int32)
const carmicache = zeros(Int32, maxcached) # NB: 8 gigabytes memory used for this size cache
const rlock = ReentrantLock()

""" Carmichael reduced totient function lambda(n) """
function lambda(n::Integer)
    @assert n > 0
    n <= maxcached && carmicache[n] > 0 && return Int(carmicache[n])
    lam = 1
    for (p, e) in factor(n)
        if p == 2 && e > 2
            lam = lcm(lam, 2^(e - 2))
        else
            lam = lcm(lam, (p - 1) * p^(e - 1))
        end
    end
    if n <= maxcached
        lock(rlock)
        carmicache[n] = lam
        unlock(rlock)
    end
    return lam
end

"""
Return k for the k-fold iterated lambda function, where k is count of iterations to 1
"""
function iterated_lambdas_to_one(i)
    k = 0
    while i > 1
        i = lambda(i)
        k += 1
    end
    return k
end

"""
    Calculate values for the task. Due to a runtime of several days for a sequence length
    of 25, the function switches to multithreading for values over about 2 billion. Note
    that (empirically) adjacent pairs of values within the sequence above 100000 are less
    than a factor of 6 apart, so each next large value is sought within that range.
"""
function print_iterated_lambdas(upto = 25)
    println("Listing of (n, lambda(n), k for iteration to 1) for integers from 1 to 25:")
    firsts = zeros(Int, upto)
    if isfile("lambdas.txt")
        precalc = readdlm("lambdas.txt", Int64)
        if length(precalc) == upto
            firsts .= precalc # restore work done if resterted (since it takes days)
        end
    end
    for i = 1:25
        lam = lambda(i)
        k = iterated_lambdas_to_one(i)
        print("($i, $lam, $k)", i % 5 == 0 ? "\n" : "  ")
    end
    target = something(findlast(!iszero, firsts), 1)
    if firsts[target] < maxcached ÷ 7 # get first ones with single thread
        for i = 2:maxcached
            n = iterated_lambdas_to_one(i)
            if n <= upto && (firsts[n] == 0 || firsts[n] > i)
                firsts[n] = i
            end
        end
    end
    target = something(findlast(!iszero, firsts), 1) + 1
    while target <= upto # multithreaded for larger targets
        startval = firsts[target - 1] + 1
        for j in startval:startval:startval*6
            j += iseven(j) # make odd
            @Threads.threads for i in j:2:j+startval-1 # should not be even if i > 2
                n = iterated_lambdas_to_one(i)
                if n == target
                    if firsts[n] == 0 || firsts[n] > i
                        try
                            lock(rlock)
                            firsts[n] = i
                            writedlm("lambdas.txt", firsts) # save work done for restarts
                            unlock(rlock)
                        catch y
                            unlock(rlock)
                            @warn y
                            rethrow()
                        end
                    end
                    break
                end
                firsts[target] > 0 && firsts[target] < i && break
            end
        end
        target += 1
    end
    println("\nIterations to 1     n      lambda(n)\n=====================================")
    println("   0                1             1")
    for n = 1:upto
        println(lpad(n, 4) * lpad(firsts[n], 17) * lpad(lambda(firsts[n]), 14))
    end
end

print_iterated_lambdas()
