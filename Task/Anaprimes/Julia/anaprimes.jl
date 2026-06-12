""" rosettacode.org task Anaprimes """


using Primes

@time for pow10 = 2:9
    parr = primes(10^pow10, 10^(pow10 + 1))
    anap = map(n -> evalpoly(10, sort!(digits(n))), parr)
    anasorted = sort(anap)
    longest, maxlen, maxstart, maxend = 0, 1, 1, 1
    while maxstart < length(anasorted)
        maxend = searchsortedfirst(anasorted, anasorted[maxstart] + 1)
        if maxlen <= maxend - maxstart
            maxlen = maxend - maxstart
            longest = anasorted[maxend - 1]
        end
        maxstart = maxend
    end
    println(
        "For $(pow10 + 1)-digit primes, a largest anagram group, [",
        parr[findfirst(==(longest), anap)],
        ", ..",
        parr[findlast(==(longest), anap)],
        "], has a group size of $maxlen.",
    )
end
