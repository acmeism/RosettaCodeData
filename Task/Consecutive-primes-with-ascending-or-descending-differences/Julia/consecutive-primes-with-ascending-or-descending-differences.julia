using Primes

function primediffseqs(maxnum = 1_000_000)
    mprimes = primes(maxnum)
    diffs = map(p -> mprimes[p[1] + 1] - p[2], enumerate(@view mprimes[begin:end-1]))
    incstart, decstart, bestinclength, bestdeclength = 1, 1, 0, 0
    for i in 1:length(diffs)-1
        foundinc, founddec = false, false
        for j in i+1:length(diffs)
            if !foundinc && diffs[j] <= diffs[j - 1]
                if (runlength = j - i) > bestinclength
                    bestinclength, incstart = runlength, i
                end
                foundinc = true
            end
            if !founddec && diffs[j] >= diffs[j - 1]
                if (runlength = j - i) > bestdeclength
                    bestdeclength, decstart = runlength, i
                end
                founddec = true
            end
            foundinc && founddec && break
        end
    end
    println("Ascending: ", mprimes[incstart:incstart+bestinclength], " Diffs: ", diffs[incstart:incstart+bestinclength-1])
    println("Descending: ", mprimes[decstart:decstart+bestdeclength], " Diffs: ", diffs[decstart:decstart+bestdeclength-1])
end

primediffseqs()
