using Primes

function solverow(row, pos, avail)
    results, nresults = Int[], 0
    for (i, tf) in enumerate(avail)
        if tf && isprime(row[pos - 1] + i + 1)
            if pos >= length(row) - 1 && isprime(row[end] + i + 1)
                row[pos] = i + 1
                return (copy(row), 1)
            else
                row[pos] = i + 1
                newav = copy(avail)
                newav[i] = false
                newresults, n = solverow(copy(row), pos + 1, newav)
                nresults += n
                results = isempty(results) && !isempty(newresults) ? newresults : results
            end
        end
    end
    return results, nresults
end

function primetriangle(nrows::Integer)
    nrows < 2 && error("number of rows requested must be > 1")
    counts, rowstrings = [1; zeros(Int, nrows - 1)], ["" for _ in 1:nrows]
    for r in 2:nrows
        p, n = solverow(collect(1:r+1), 2, trues(r - 1))
        rowstrings[r] = prod([lpad(n, 3) for n in p]) * "\n"
        counts[r] = n
    end
    println("  1  2\n" * prod(rowstrings), "\n", counts)
end
