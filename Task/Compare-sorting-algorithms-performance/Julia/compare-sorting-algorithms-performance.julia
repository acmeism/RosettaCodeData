function comparesorts(tosort)
    a = shuffle(["i", "m", "q"])
    iavg = mavg = qavg = 0.0
    for c in a
        if c == "i"
            iavg = sum(i -> @elapsed(sort(tosort, alg=InsertionSort)), 1:100) / 100.0
        elseif c == "m"
            mavg = sum(i -> @elapsed(sort(tosort, alg=MergeSort)), 1:100) / 100.0
        elseif c == "q"
            qavg = sum(i -> @elapsed(sort(tosort, alg=QuickSort)), 1:100) / 100.0
        end
    end
    iavg, mavg, qavg
end

allones = fill(1, 40000)
sequential = collect(1:40000)
randomized = collect(shuffle(1:40000))

comparesorts(allones)
comparesorts(allones)
iavg, mavg, qavg = comparesorts(allones)
println("Average sort times for 40000 ones:")
println("\tinsertion sort:\t$iavg\n\tmerge sort:\t$mavg\n\tquick sort\t$qavg")

comparesorts(sequential)
comparesorts(sequential)
iavg, mavg, qavg = comparesorts(sequential)
println("Average sort times for 40000 presorted:")
println("\tinsertion sort:\t$iavg\n\tmerge sort:\t$mavg\n\tquick sort\t$qavg")

comparesorts(randomized)
comparesorts(randomized)
iavg, mavg, qavg = comparesorts(randomized)
println("Average sort times for 40000 randomized:")
println("\tinsertion sort:\t$iavg\n\tmerge sort:\t$mavg\n\tquick sort\t$qavg")
