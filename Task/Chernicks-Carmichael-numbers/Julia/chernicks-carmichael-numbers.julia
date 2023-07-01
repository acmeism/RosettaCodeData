using Primes

function trial_pretest(k::UInt64)

    if ((k %  3)==0 || (k %  5)==0 || (k %  7)==0 || (k % 11)==0 ||
        (k % 13)==0 || (k % 17)==0 || (k % 19)==0 || (k % 23)==0)
        return (k <= 23)
    end

    return true
end

function gcd_pretest(k::UInt64)

    if (k <= 107)
        return true
    end

    gcd(29*31*37*41*43*47*53*59*61*67, k) == 1 &&
    gcd(71*73*79*83*89*97*101*103*107, k) == 1
end

function is_chernick(n::Int64, m::UInt64)

    t = 9*m

    if (!trial_pretest(6*m + 1))
        return false
    end

    if (!trial_pretest(12*m + 1))
        return false
    end

    for i in 1:n-2
        if (!trial_pretest((t << i) + 1))
            return false
        end
    end

    if (!gcd_pretest(6*m + 1))
        return false
    end

    if (!gcd_pretest(12*m + 1))
        return false
    end

    for i in 1:n-2
        if (!gcd_pretest((t << i) + 1))
            return false
        end
    end

    if (!isprime(6*m + 1))
        return false
    end

    if (!isprime(12*m + 1))
        return false
    end

    for i in 1:n-2
        if (!isprime((t << i) + 1))
            return false
        end
    end

    return true
end

function chernick_carmichael(n::Int64, m::UInt64)
    prod = big(1)

    prod *= 6*m + 1
    prod *= 12*m + 1

    for i in 1:n-2
        prod *= ((big(9)*m)<<i) + 1
    end

    prod
end

function cc_numbers(from, to)

    for n in from:to

        multiplier = 1

        if (n > 4) multiplier = 1 << (n-4) end
        if (n > 5) multiplier *= 5 end

        m = UInt64(multiplier)

        while true

            if (is_chernick(n, m))
                println("a(", n, ") = ", chernick_carmichael(n, m))
                break
            end

            m += multiplier
        end
    end
end

cc_numbers(3, 10)
