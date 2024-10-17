using Primes

function amicable_numbers(max::Integer = 200_000_000)

    function sum_proper_divisors(n::Integer)
        sum(vec(map(prod, Iterators.product((p.^(0:m) for (p, m) in factor(n))...)))) - n
    end

    count = 0
    cumsum = 0

    println("count, a, b, a+b, Sum(a+b)")

    for a in 2:max
        isprime(a) && continue
        b = sum_proper_divisors(a)
        if a < b && sum_proper_divisors(b) == a
            count += 1
            sumab = a + b
            cumsum += sumab
            println("$count, $a, $b, $sumab, $cumsum")
        end
    end
end

amicable_numbers()
