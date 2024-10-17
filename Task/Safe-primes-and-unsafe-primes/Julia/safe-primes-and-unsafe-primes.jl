using Primes, Formatting

function parseprimelist()
    primelist = primes(2, 10000000)
    safeprimes = Vector{Int64}()
    unsafeprimes = Vector{Int64}()
    for p in primelist
        if isprime(div(p - 1, 2))
            push!(safeprimes, p)
        else
            push!(unsafeprimes, p)
        end
    end
    println("The first 35 unsafe primes are: ", safeprimes[1:35])
    println("There are ", format(sum(map(x -> x < 1000000, safeprimes)), commas=true), " safe primes less than 1 million.")
    println("There are ", format(length(safeprimes), commas=true), " safe primes less than 10 million.")
    println("The first 40 unsafe primes are: ", unsafeprimes[1:40])
    println("There are ", format(sum(map(x -> x < 1000000, unsafeprimes)), commas=true), " unsafe primes less than 1 million.")
    println("There are ", format(length(unsafeprimes), commas=true), " unsafe primes less than 10 million.")
end

parseprimelist()
