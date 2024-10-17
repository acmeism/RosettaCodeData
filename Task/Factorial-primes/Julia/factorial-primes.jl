using Primes

limitedprint(n) = (s = string(n); n = length(s); return n <= 40 ? s : s[1:20] * "..." * s[end-19:end] * " ($n digits)")

function showfactorialprimes(N)
    for i in big"1":N
        f = factorial(i)
        isprime(f - 1) && println(lpad(i, 3), "! - 1 -> ", limitedprint(f - 1))
        isprime(f + 1) && println(lpad(i, 3), "! + 1 -> ", limitedprint(f + 1))
    end
end

showfactorialprimes(1000)
