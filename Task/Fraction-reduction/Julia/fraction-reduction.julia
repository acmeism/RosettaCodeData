using Combinatorics

toi(set) = parse(Int, join(set, ""))
drop1(c, set) = toi(filter(x -> x != c, set))

function anomalouscancellingfractions(numdigits)
    ret = Vector{Tuple{Int, Int, Int, Int, Int}}()
    for nset in permutations(1:9, numdigits), dset in permutations(1:9, numdigits)
        if nset < dset # only proper fractions
            for c in nset
                if c in dset # a common digit exists
                    n, d, nn, dd = toi(nset), toi(dset), drop1(c, nset), drop1(c, dset)
                    if n // d == nn // dd # anomalous cancellation
                        push!(ret, (n, d, nn, dd, c))
                    end
                end
            end
        end
    end
    ret
end

function testfractionreduction(maxdigits=5)
    for i in 2:maxdigits
        results = anomalouscancellingfractions(i)
        println("\nFor $i digits, there were ", length(results),
            " fractions with anomalous cancellation.")
        numcounts = zeros(Int, 9)
        for r in results
            numcounts[r[5]] += 1
        end
        for (j, count) in enumerate(numcounts)
            count > 0 && println("The digit $j was crossed out $count times.")
        end
        println("Examples:")
        for j in 1:min(length(results), 12)
            r = results[j]
            println(r[1], "/", r[2], " = ", r[3], "/", r[4], "   ($(r[5]) crossed out)")
        end
    end
end

testfractionreduction()
