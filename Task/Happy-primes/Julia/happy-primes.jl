using Primes


const digbuf = zeros(Int, 12) # Buffer for digits!() call

function ishappy(n::Int)
    while n != 1 && n != 4
        digits!(digbuf, n)
        n = sum(d * d for d in digbuf if d != 0; init = 0)
    end
    return n == 1
end

const happy_prime_nums = Iterators.filter(x -> ishappy(x) && isprime(x), Iterators.countfrom(1))
println("First fifty happy primes:")
const happy_primes = Iterators.take(happy_prime_nums, 50) |> collect
for i in 1:50
    print(lpad(happy_primes[i], 4))
    print(i % 10 == 0 ? "\n" : " ")
end

""" Find indices where happys have outgrown prime happys to shrink their fraction """
function findprimefractions()
    println("\nPrime\nFraction   Index     Value\n", "="^26)
    index, n = 1, 2
    prime_count = 0
    happy_nums = Iterators.filter(ishappy, Iterators.countfrom(2))
    for d in 2:15
        while true
            index += 1
            (n, happy_nums) = Iterators.peel(happy_nums)
            if isprime(n)
                prime_count += 1
            end
            if prime_count / index <= 1/d
                break
            end
        end
        println("1 / ", lpad(d, 2), lpad(index, 10), lpad(n, 10))
    end
end

findprimefractions()
