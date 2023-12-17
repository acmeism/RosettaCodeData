function modpow(b, e, m,   r) {
    for (r = 1; e > 0; e = int(e / 2)) {
        if (e % 2 == 1)
            r = r * b % m
        b = b * b % m
    }
    return r
}

function is_pseudo(n,   i, p, r) {
    if (modpow(10, n - 1, n) == 1) {
        r = int(sqrt(n))
        while ((p = primes[++i]) <= r)
            if (n % p == 0)
                return 1
        primes[++l] = n
    }
    return 0
}

BEGIN {
    primes[l = 1] = n = 7
    split("4 2 4 2 4 6 2 6", wheel)

    do if (is_pseudo(n += wheel[i = i % 8 + 1])) {
        printf " %u", n
        ++c
    } while (c != 50)
    print
}
