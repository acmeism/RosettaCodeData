# v0.6

function sumdigits(n::Integer)
    sum = 0
    while n > 0
        sum += n % 10
        n = div(n, 10)
    end
    return sum
end

using Primes
issmith(n::Integer) = !isprime(n) && sumdigits(n) == sum(sumdigits(f) for f in factor(Vector, n))

smithnumbers = collect(n for n in 2:10000 if issmith(n))
println("Smith numbers up to 10000:\n$smithnumbers")
