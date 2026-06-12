""" rosettacode.org/wiki/One-two_primes """

using IntegerMathUtils # for the call to libgmp's gmpz_probab_prime_p

""" From Chai Wah Wu's Python code at oeis.org/A036229 """
function show_oeis36229(wanted = 2000)
    for ndig in vcat(1:20, 100:100:wanted)
        k, r, m = (big"10"^ndig - 1) ÷ 9, big"2"^ndig - 1, big"0"
        while m <= r
            t = k + parse(BigInt, string(m, base = 2))
            if is_probably_prime(t)
                pstr = string(t)
                if ndig < 21
                    println(lpad(ndig, 4), ": ", pstr)
                else
                    k = something(findfirst(!=('1'), pstr), ndig) - 1
                    println(lpad(ndig, 4), ": (1 x $k) ", pstr[k:end])
                end
                break
            end
            m += 1
        end
    end
end

show_oeis36229()
