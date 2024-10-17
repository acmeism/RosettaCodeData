""" rosettacode.org/wiki/Prime_numbers_whose_neighboring_pairs_are_tetraprimes """

using Statistics
using Primes

istetraprime(n) = (a = map(last, factor(n).pe); length(a) == 4 && all(==(1), a))
are_following_tetraprimes(n, cnt = 2) = all(istetraprime, n+1:n+cnt)
are_preceding_tetraprimes(n, cnt = 2) = all(istetraprime, n-cnt:n-1)

let
    primes1M = primes(10^7)
    pre1M = filter(are_preceding_tetraprimes, primes1M)
    fol1M = filter(are_following_tetraprimes, primes1M)
    pre100k = filter(<(100_000), pre1M)
    fol100k = filter(<(100_000), fol1M)

    pre1M_with7 = filter(i -> any(k -> (i - k) % 7 == 0, 1:2), pre1M)
    fol1M_with7 = filter(i -> any(k -> (i + k) % 7 == 0, 1:2), fol1M)
    pre100k_with7 = filter(<(100_000), pre1M_with7)
    fol100k_with7 = filter(<(100_000), fol1M_with7)

    p_gaps1M = [pre1M[i] - pre1M[i - 1] for i in 2:lastindex(pre1M)]
    f_gaps1M = [fol1M[i] - fol1M[i - 1] for i in 2:lastindex(fol1M)]
    p_gaps100k = [pre1M[i] - pre1M[i - 1] for i in 2:lastindex(pre1M) if pre1M[i] < 100_000]
    f_gaps100k = [fol1M[i] - fol1M[i - 1] for i in 2:lastindex(fol1M) if fol1M[i] < 100_000]

    pmin1M, pmedian1M, pmax1M = minimum(p_gaps1M), median(p_gaps1M), maximum(p_gaps1M)
    fmin1M, fmedian1M, fmax1M = minimum(f_gaps1M), median(f_gaps1M), maximum(f_gaps1M)
    pmin100k, pmedian100k, pmax100k = minimum(p_gaps100k), median(p_gaps100k), maximum(p_gaps100k)
    fmin100k, fmedian100k, fmax100k = minimum(f_gaps100k), median(f_gaps100k), maximum(f_gaps100k)

    for (tet, s, s2, tmin, tmed, tmax, t7) in [
        (pre100k, "100,000", "preceding", pmin100k, pmedian100k, pmax100k, pre100k_with7),
        (fol100k, "100,000", "following", fmin100k, fmedian100k, fmax100k, fol100k_with7),
        (pre1M, "1,000,000", "preceding", pmin1M, pmedian1M, pmax1M, pre1M_with7),
        (fol1M, "1,000,000", "following", fmin1M, fmedian1M, fmax1M, fol1M_with7),
    ]
        print("Found $(length(tet)) primes under $s whose $s2 neighboring pair are tetraprimes")
        if s == "100,000"
            println(":")
            foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(tet))
            println()
        else
            println(".")
        end
        println("Minimum, median, and maximum gaps between those primes: $tmin $tmed $tmax")
        println("Of those primes, $(length(t7)) have a neighboring pair one of whose factors is 7.\n")
    end
end
