using Primes

function getgiugas(numberwanted, verbose = true)
    n, found, nfound = 6, Int[], 0
    starttime = time()
    while nfound < numberwanted
        if n % 5 == 0 || n % 7 == 0 || n % 11 == 0
            for (p, e) in eachfactor(n)
                (e != 1 || rem(n ÷ p - 1, p) != 0) && @goto nextnumber
            end
            verbose && println(n, "  (elapsed: ", time() - starttime, ")")
            push!(found, n)
            nfound += 1
        end
        @label nextnumber
        n += 6 # all mult of 6
    end
    return found
end

@time getgiugas(2, false)
@time getgiugas(6)
