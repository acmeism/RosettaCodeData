using Primes

function rajpairs(N, verbose, interval = 2)
    maxpossramanujan(n) = Int(ceil(4n * log(4n) / log(2)))
    prm = primes(maxpossramanujan(N))
    pivec = accumulate(+, primesmask(maxpossramanujan(N)))
    halfrpc = [pivec[p] - pivec[p ÷ 2] for p in prm]
    lastrpc = last(halfrpc) + 1
    for i in length(halfrpc):-1:1
        if halfrpc[i] < lastrpc
            lastrpc = halfrpc[i]
        else
            halfrpc[i] = 0
        end
    end
    rajvec = [prm[i] for i in eachindex(prm) if halfrpc[i] > 0]
    nrajtwins = count(rajvec[i] + interval == rajvec[i + 1] for i in 1:N-1)
    verbose && println("There are $nrajtwins twins in the first $N Ramanujan primes.")
    return nrajtwins
end

rajpairs(100000, false)
@time rajpairs(1000000, true)
