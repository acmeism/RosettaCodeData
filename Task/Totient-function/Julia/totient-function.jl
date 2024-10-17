φ(n) = sum(1 for k in 1:n if gcd(n, k) == 1)

is_prime(n) = φ(n) == n - 1

function runphitests()
    for n in 1:25
        println(" φ($n) == $(φ(n))", is_prime(n) ? ", is prime" : "")
    end
    count = 0
    for n in 1:100_000
        count += is_prime(n)
        if n in [100, 1000, 10_000, 100_000]
            println("Primes up to $n: $count")
        end
    end
end

runphitests()
