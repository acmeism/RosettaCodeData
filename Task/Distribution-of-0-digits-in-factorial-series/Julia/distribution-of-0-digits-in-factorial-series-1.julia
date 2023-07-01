function meanfactorialdigits(N, goal = 0.0)
    factoril, proportionsum = big"1", 0.0
    for i in 1:N
        factoril *= i
        d = digits(factoril)
        zero_proportion_in_fac = count(x -> x == 0, d) / length(d)
        proportionsum += zero_proportion_in_fac
        propmean = proportionsum / i
        if i > 15 && propmean <= goal
            println("The mean proportion dips permanently below $goal at $i.")
            break
        end
        if i == N
            println("Mean proportion of zero digits in factorials to $N is ", propmean)
        end
    end
end

@time foreach(meanfactorialdigits, [100, 1000, 10000])

@time meanfactorialdigits(50000, 0.16)
