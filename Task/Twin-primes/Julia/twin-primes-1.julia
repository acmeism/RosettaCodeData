using Formatting, Primes

function counttwinprimepairsbetween(n1, n2)
    npairs, t = 0, nextprime(n1)
    while t < n2
        p = nextprime(t + 1)
        if p - t == 2
            npairs += 1
        end
        t = p
    end
    return npairs
end

for t2 in (10).^collect(2:8)
    paircount = counttwinprimepairsbetween(1, t2)
    println("Under", lpad(format(t2, commas=true), 12), " there are",
        lpad(format(paircount, commas=true), 8), " pairs of twin primes.")
end
