function braziliandensities(N, interval)
    count, intervalcount, icount = 0, 0, 0
    intervalcounts = Int[]
    for i in 7:typemax(Int)
        intervalcount += 1
        if intervalcount > interval
            push!(intervalcounts, icount)
            intervalcount = 0
            icount = 0
        end
        if isbrazilian(i)
            icount += 1
            count += 1
            if count == N
                println("The $N th brazilian is $i.")
                return [n/interval for n in intervalcounts]
            end
        end
    end
end

braziliandensities(10000, 100)
braziliandensities(100000, 1000)
plot(1:1000:1000000, braziliandensities(1000000, 1000))
