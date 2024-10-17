using Primes, Lazy, Formatting

function isunprimeable(n)
    dvec = digits(n)
    for pos in 1:length(dvec), newdigit in 0:9
        olddigit, dvec[pos] = dvec[pos], newdigit
        isprime(foldr((i, j) -> i + 10j, dvec)) && return false
        dvec[pos] = olddigit
    end
    return true
end

println("First 35 unprimeables: ", take(35, filter(isunprimeable, Lazy.range())))

println("\nThe 600th unprimeable is ",
    collect(take(600, filter(isunprimeable, Lazy.range())))[end])

println("\nDigit  First unprimeable ending with that digit")
println("-----------------------------------------")

for dig in 0:9
    n = first(filter(x -> (x % 10 == dig) && isunprimeable(x), Lazy.range()))
    println("  $dig  ", lpad(format(n, commas=true), 9))
end
