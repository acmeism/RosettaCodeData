""" Rosetta code task: rosettacode.org/wiki/Primes:_n*2%5Em%2B1 """

using Primes

""" Return true if there is an m such that n * 2**m + 1 is prime """
function n2m1(n)
    for m in big"0":big"10"^300
        isprime(n * big"2"^m + 1) && return true, m
    end
    return false, 0
end

println("  N      M  Prime\n------------------")
for n in 1:400
    tf, m = n2m1(n)
    tf && println(lpad(n, 5), lpad(m, 5), "  ", n * big"2"^m + 1)
end
