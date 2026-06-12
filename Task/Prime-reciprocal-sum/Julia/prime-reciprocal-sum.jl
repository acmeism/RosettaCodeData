""" rosettacode.org/wiki/Prime_reciprocal_sum """

using Primes
using ResumableFunctions

""" Abbreviate a large string by showing beginning / end and number of chars """
function abbreviate(s; ds = "digits", t = 40, x = (t - 1) ÷ 2)
    wid = length(s)
    return wid < t ? s : s[begin:begin+x] * ".." * s[end-x:end] * " ($wid $ds)"
end

@resumable function generate_oeis75442()
    psum = big"0" // big"1"
    while true
        n = BigInt(ceil(big"1" // (1 - psum)))
        while true
            n = nextprime(n + 1)
            if psum + 1 // n < 1
                psum += 1 // n
                @yield n
                break
            end
        end
    end
end

for (i, n) in enumerate(Iterators.take(generate_oeis75442(), 17))
    println(lpad(i, 2), ": ", abbreviate(string(n)))
end
