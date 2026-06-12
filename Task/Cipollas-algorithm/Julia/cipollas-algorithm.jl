using Primes

function legendre(n, p)
    if p != 2 && isprime(p)
        x = powermod(BigInt(n), div(p - 1, 2), p)
        return x == 0 ? 0 : x == 1 ? 1 : -1
    end
    return -1
end

function cipolla(n, p)
    if legendre(n, p) != 1
        return NaN
    end
    a, w2 = BigInt(0), BigInt(0)
    while true
        w2 = (a^2 + p - n) % p
        if legendre(w2, p) < 0
            break
        end
        a += 1
    end
    r, s, i = (1, 0), (a, 1), p + 1
    while (i >>= 1) > 0
        if isodd(i)
            r = ((r[1] * s[1] + r[2] * s[2] * w2) % p, (r[1] * s[2] + s[1] * r[2]) % p)
        end
        s = ((s[1] * s[1] + s[2] * s[2] * w2) % p, (2 * s[1] * s[2]) % p)
    end
    return r[2] != 0 ? NaN : r[1]
end

const ctests = [(10, 13),
                (56, 101),
                (8218, 10007),
                (8219, 10007),
                (331575, 1000003),
                (665165880, 1000000007),
                (881398088036, 1000000000039),
                (big"34035243914635549601583369544560650254325084643201",
                    big"100000000000000000000000000000000000000000000000151")]

for (n, p) in ctests
   r = cipolla(n, p)
   println(r > 0 ? "Roots of $n are ($r, $(p - r)) mod $p." : "No solution for ($n, $p)")
end
