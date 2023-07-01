using Lazy, Primes

function iscircularprime(n)
    !isprime(n) && return false
    dig = digits(n)
    return all(i -> (m = evalpoly(10, circshift(dig, i))) >= n && isprime(m), 1:length(dig)-1)
end

filtcircular(n, rang) = Int.(collect(take(n, filter(iscircularprime, rang))))
isprimerepunit(n) = isprime(evalpoly(BigInt(10), ones(Int, n)))
filtrep(n, rang) = collect(take(n, filter(isprimerepunit, rang)))

println("The first 19 circular primes are:\n", filtcircular(19, Lazy.range(2)))
print("\nThe next 4 circular primes, in repunit format, are: ",
    mapreduce(n -> "R($n) ", *, filtrep(4, Lazy.range(6))))

println("\n\nChecking larger repunits:")
for i in [5003, 9887, 15073, 25031, 35317, 49081]
    println("R($i) is ", isprimerepunit(i) ? "prime." : "not prime.")
end
