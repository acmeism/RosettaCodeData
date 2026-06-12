""" rosettacode.orgwiki/Least_m_such_that_n!_%2B_m_is_prime """

using Primes

function least_m_fact_to_prime(number_to_print, delta_limit)
    fact, p, m, n, t = big"1", big"0", big"0", 0, 1000
    diffs = zeros(BigInt, number_to_print)
    while true
        if n > 0
            fact *= n
            p = nextprime(fact + 1)
            m = p - fact
            if n < number_to_print
                diffs[n] = m
            end
            if n == number_to_print - 1
                println("Least positive m such that n! + m is prime; first $number_to_print:")
                for (i, k) in enumerate(diffs)
                    print(lpad(k, 5), i % 10 == 0 ? "\n" : "")
                end
            elseif m > t
                while true
                    print("\nFirst m > $t is $m at position $n.")
                    t += 1000
                    if m <= t
                        break
                    end
                end
                if t > delta_limit
                    return
                end
            end
        end
        n += 1
    end
end

least_m_fact_to_prime(50, 10_000)
