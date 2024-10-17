using Primes

"""
    function wastefulness(n, base = 10)

calculate d1: the number of digits in base `base` required to write the factor expansion of
`n`, ie 12 -> 2^2 * 3^2 is 4 digits, 7 -> 7 is 1 digit, 20 -> 5 * 2^2 is 3 digits

calculate d2: the number of digits in base `base` to represent `n` itself

return -1 if frugal (d1 > d2), 0 if equidigital (d1 == d2), 1 if wasteful (d1 > d2)
"""
function wastefulness(n::Integer, base = 10)
    @assert n > 0
    return n == 1 ? 0 :
       sign(sum(p -> ndigits(p[1], base=base) +
       (p[2] == 1 ? 0 : ndigits(p[2], base=base)),
       factor(n).pe) -
       ndigits(n, base=base))
end

for b in [10, 11]
    w50, e50, f50 = Int[], Int[], Int[]
    w10k, e10k, f10k, wcount, ecount, fcount, wm, em, fm = 0, 0, 0, 0, 0, 0, 0, 0, 0
    for n in 1:10_000_000
        sgn = wastefulness(n, b)
        if sgn < 0
            fcount < 50 && push!(f50, n)
            fcount += 1
            fcount == 10000 &&(f10k = n)
            n < 1_000_000 && (fm += 1)
        elseif sgn == 0
            ecount < 50 && push!(e50, n)
            ecount += 1
            ecount == 10000 && (e10k = n)
            n < 1_000_000 && (em += 1)
        else # sgn > 0
            wcount < 50 && push!(w50, n)
            wcount += 1
            wcount == 10000  && (w10k = n)
            n < 1_000_000 && (wm += 1)
        end
        if f10k > 0
            println("FOR BASE $b:\n")
            println("First 50 Wasteful numbers:")
            foreach(p -> print(rpad(p[2], 5), p[1] % 10 == 0 ? "\n" : ""), pairs(w50))
            println("\nFirst 50 Equidigital numbers:")
            foreach(p -> print(rpad(p[2], 5), p[1] % 10 == 0 ? "\n" : ""), pairs(e50))
            println("\nFirst 50 Frugal numbers:")
            foreach(p -> print(rpad(p[2], 5), p[1] % 10 == 0 ? "\n" : ""), pairs(f50))
            println("\n10,000th Wasteful number   : $w10k")
            println("10,000th Equidigital number  : $e10k")
            println("10,000th Frugal number       : $f10k")
            println("\nFor natural numbers < 1 million, the breakdown is as follows:")
            println("  Wasteful numbers    : $wm")
            println("  Equidigital numbers : $em")
            println("  Frugal numbers      : $fm\n\n")
            break
        end
    end
end
