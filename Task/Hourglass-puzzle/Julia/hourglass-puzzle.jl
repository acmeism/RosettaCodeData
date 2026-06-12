function euclidean_hourglassflipper(hourglasses, target::Integer)
    gcd(hourglasses) in hourglasses && !(1 in hourglasses) && throw("Hourglasses fail sanity test (not relatively prime enough)")
    flippers, series = deepcopy(hourglasses), Int[]
    for i in 1:typemax(target)
        n = minimum(flippers)
        push!(series, n)
        flippers .-= n
        for (i, n) in enumerate(flippers)
            if n == 0
                flippers[i] = hourglasses[i]
            end
        end
        for startpoint in length(series):-1:1
            if sum(series[startpoint:end]) == target
                println("Series: $series")
                return startpoint, length(series)
            end
        end
    end
end

println("Flip an hourglass every time it runs out of grains, and note the interval in time.")
i, j = euclidean_hourglassflipper([4, 7], 9)
println("Use hourglasses from step $i to step $j (inclusive) to sum 9 using [4, 7]")
i, j = euclidean_hourglassflipper([5, 7, 31], 36)
println("Use hourglasses from step $i to step $j (inclusive) to sum 36 using [5, 7, 31]")
