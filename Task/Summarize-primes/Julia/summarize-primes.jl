using Primes

p1000 = primes(1000)

for n in 1:length(p1000)
    parray = p1000[1:n]
    sparray = sum(parray)
    if isprime(sparray)
        println("The sum of the $n primes from prime 2 to prime $(p1000[n]) is $sparray, which is prime.")
    end
end
