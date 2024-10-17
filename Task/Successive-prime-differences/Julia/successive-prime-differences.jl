using Primes

function filterdifferences(deltas, N)
    allprimes = primes(N)
    differences = map(i -> allprimes[i + 1] - allprimes[i], 1:length(allprimes) - 1)
    println("Diff Sequence   Count         First           Last")
    for delt in deltas
        ret = trues(length(allprimes) - length(delt))
        for j in 1:length(ret)
            for (i, d) in enumerate(delt)
                if differences[j - 1 + i] != d
                    ret[j] = false
                    break
                end
            end
        end
        count, p1, pn, n = sum(ret), findfirst(ret), findlast(ret), length(delt)
        println(rpad(string(delt), 16), lpad(count, 4),
            lpad(string(allprimes[p1:p1 + n]), 18), "...", rpad(allprimes[pn:pn+n], 15))
    end
end

filterdifferences([[2], [1], [2, 2], [2, 4], [4, 2], [6, 4, 2]], 1000000)
