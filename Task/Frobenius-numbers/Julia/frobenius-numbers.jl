using Primes

const primeslt10k = primes(10000)
frobenius(n) = begin (x, y) = primeslt10k[n:n+1]; x * y - x - y end

function frobeniuslessthan(maxnum)
    frobpairs = Pair{Int, Bool}[]
    for n in 1:maxnum
        frob = frobenius(n)
        frob > maxnum && break
        push!(frobpairs, Pair(frob, isprime(frob)))
    end
    return frobpairs
end

function testfrobenius()
    println("Frobenius numbers less than 1,000,000 (an asterisk marks the prime ones).")
    frobpairs = frobeniuslessthan(1_000_000)
    for (i, p) in enumerate(frobpairs)
        print(rpad(string(p[1]) * (p[2] ? "*" : ""), 8), i % 10 == 0 ? "\n" : "")
    end
end

testfrobenius()
