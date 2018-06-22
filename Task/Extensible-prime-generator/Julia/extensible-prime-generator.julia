using Primes

sum = 2
currentprime = 2
for i in 2:100000
    currentprime = nextprime(currentprime + 1)
    sum += currentprime
end
println("The sum of the first 100,000 primes is $sum")

curprime = 1
arr = zeros(Int, 20)
for i in 1:20
    curprime = nextprime(curprime + 1)
    arr[i] = curprime
end
println("The first 20 primes are ", arr)

println("the primes between 100 and 150 are ", primes(100,150))
println("The number of primes between 7,700 and 8,000 is ", length(primes(7700, 8000)))
println("The 10,000th prime is ", prime(10000))
