using Primes, Formatting

function parseprimelist()
    primelist = primes(2, 10000019)
    strongs = Vector{Int64}()
    weaks = Vector{Int64}()
    balanceds = Vector{Int64}()
    for (n, p) in enumerate(primelist)
        if n == 1 || n == length(primelist)
            continue
        end
        x = (primelist[n - 1] + primelist[n + 1]) / 2
        if x > p
            push!(weaks, p)
        elseif x < p
            push!(strongs, p)
        else
            push!(balanceds, p)
        end
    end
    println("The first 36 strong primes are: ", strongs[1:36])
    println("There are ", format(sum(map(x -> x < 1000000, strongs)), commas=true), " stromg primes less than 1 million.")
    println("There are ", format(length(strongs), commas=true), " strong primes less than 10 million.")
    println("The first 37 weak primes are: ", weaks[1:37])
    println("There are ", format(sum(map(x -> x < 1000000, weaks)), commas=true), " weak primes less than 1 million.")
    println("There are ", format(length(weaks), commas=true), " weak primes less than 10 million.")
    println("The first 28 balanced primes are: ", balanceds[1:28])
    println("There are ", format(sum(map(x -> x < 1000000, balanceds)), commas=true), " balanced primes less than 1 million.")
    println("There are ", format(length(balanceds), commas=true), " balanced primes less than 10 million.")
end

parseprimelist()
