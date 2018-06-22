using StatsBase

function runall()
    nbuckets = 16
    unfinish = true
    spinner = ReentrantLock()
    buckets = rand(1:99, nbuckets)
    totaltrans = 0

    bucketsum() = sum(buckets)
    smallpause() = sleep(rand() / 2000)
    picktwo() = (samplepair(nbuckets)...)
    function equalizer()
        while unfinish
            smallpause()
            if trylock(spinner)
                i, j = picktwo()
                sm = buckets[i] + buckets[j]
                m = fld(sm + 1, 2)
                buckets[i], buckets[j] = m, sm - m
                totaltrans += 1
                unlock(spinner)
            end
        end
    end
    function redistributor()
        while unfinish
            smallpause()
            if trylock(spinner)
                i, j = picktwo()
                sm = buckets[i] + buckets[j]
                buckets[i] = rand(0:sm)
                buckets[j] = sm - buckets[i]
                totaltrans += 1
                unlock(spinner)
            end
        end
    end
    function accountant()
        count = 0
        while count < 16
            smallpause()
            if trylock(spinner)
                println("Current state of buckets: $buckets. Total in buckets: $(bucketsum())")
                unlock(spinner)
                count += 1
                sleep(1)
            end
        end
        unfinish = false
    end
    t = time()
    @async equalizer()
    @async redistributor()
    @async accountant()
    while unfinish sleep(0.25) end
    println("Total transactions: $totaltrans ($(round(Int, totaltrans / (time() - t))) unlocks per second).")
end

runall()
