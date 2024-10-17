using Primes

function σ(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    return sum(f)
end

isDuffinian(n) = !isprime(n) && gcd(n, σ(n)) == 1

function testDuffinians()
    println("First 50 Duffinian numbers:")
    foreach(p -> print(rpad(p[2], 4), p[1] % 25 == 0 ? "\n" : ""),
        enumerate(filter(isDuffinian, 2:217)))
    n, found = 2, 0
    println("\nFifteen Duffinian triplets:")
    while found < 15
        if isDuffinian(n) && isDuffinian(n + 1) && isDuffinian(n + 2)
            println(lpad(n, 6), lpad(n +1, 6), lpad(n + 2, 6))
            found += 1
        end
        n += 1
    end
end

testDuffinians()
