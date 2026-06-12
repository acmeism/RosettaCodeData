using Primes

function listpiprimes(maxpi)
    pmask = primesmask(1, maxpi * maxpi)
    n = 0
    for (i, isp) in enumerate(pmask)
        isp == 1 && (n += 1) >= maxpi && break
        print(rpad(n, 3), i % 10 == 0 ? "\n" : "")
    end
end

listpiprimes(22)
