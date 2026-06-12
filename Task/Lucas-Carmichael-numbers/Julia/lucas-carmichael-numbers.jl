using Primes

const BIG = false       # true to use big integers

function big_prod(arr)
    BIG || return prod(arr)
    r = big(1)
    for n in arr
        r *= n
    end
    return r
end

function lucas_carmichael(A, B, k)

    LC = []
    max_p = isqrt(B+1)-1
    A = max(A, fld(big_prod(primes(prime(k+1))), 2))

    F = function(m, L, lo, k)

        hi = round(Int64, fld(B, m)^(1/k))

        if (lo > hi)
            return nothing
        end

        if (k == 1)

            hi = min(hi, max_p)
            lo = round(Int64, max(lo, cld(A, m)))
            lo > hi && return nothing

            t = L - invmod(m, L)
            t > hi && return nothing

            while (t < lo)
                t += L
            end

            for p in t:L:hi
                if (isprime(p))
                    n = m*p
                    if ((n+1) % (p+1) == 0)
                        push!(LC, n)
                    end
                end
            end

            return nothing
        end

        for p in primes(lo, hi)
            if (gcd(m, p+1) == 1)
                F(m*p, lcm(L, p+1), p+1, k-1)
            end
        end
    end

    F((BIG ? big(1) : 1), (BIG ? big(1) : 1), 3, k)

    return sort(LC)
end

function LC_with_n_primes(n)

    n < 3 && return nothing

    x = big_prod(primes(prime(n + 1))) >> 1
    y = 2 * x

    while true
        LC = lucas_carmichael(x, y, n)
        if (length(LC) >= 1)
            return LC[1]
        end
        x = y + 1
        y = 2 * x
    end
end

println("Least Lucas-Carmichael number with n prime factors:")

for n in 3:12
    println([n, LC_with_n_primes(n)])
end

function LC_count(A, B)
    count = 0
    for k in 3:10^6
        if (big_prod(primes(prime(k+1)))/2 > B)
            break
        end
        count += length(lucas_carmichael(A, B, k))
    end
    return count
end

println("\nNumber of Lucas-Carmichael numbers less than 10^n:")

for n in 1:10
    println([n, LC_count(1, 10^n)])
end
