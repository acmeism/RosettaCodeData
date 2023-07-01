using Lazy
using Primes

J(n) = (2^n - (-1)^n) ÷ 3
L(n) =  2^n + (-1)^n

Jacobsthal = @>> Lazy.range(0) map(J)
JLucas = @>> Lazy.range(0) map(L)
Joblong = @>> Lazy.range(big"0") map(n -> J(n) * J(n + 1))
Jprimes = @>> Lazy.range(big"0") map(J) filter(isprime)

function printrows(title, vec, columnsize = 15, columns = 5, rjust=true)
    println(title)
    for (i, n) in enumerate(vec)
        print((rjust ? lpad : rpad)(n, columnsize), i % columns == 0 ? "\n" : "")
    end
    println()
end

printrows("Thirty Jacobsthal numbers:", collect(take(30, Jacobsthal)))
printrows("Thirty Jacobsthal-Lucas numbers:", collect(take(30, JLucas)))
printrows("Twenty oblong Jacobsthal numbers:", collect(take(20, Joblong)))
printrows("Fifteen Jacabsthal prime numbers:", collect(take(15, Jprimes)), 40, 1, false)
