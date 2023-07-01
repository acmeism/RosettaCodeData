module Faulhaber

function bernoulli(n::Integer)
    n ≥ 0 || throw(DomainError(n, "n must be a positive-or-0 number"))
    a = fill(0 // 1, n + 1)
    for m in 1:n
        a[m] = 1 // (m + 1)
        for j in m:-1:2
            a[j - 1] = (a[j - 1] - a[j]) * j
        end
    end
    return ifelse(n != 1, a[1], -a[1])
end

const _exponents = collect(Char, "⁰¹²³⁴⁵⁶⁷⁸⁹")
toexponent(n) = join(_exponents[reverse(digits(n)) .+ 1])

function formula(p::Integer)
    print(p, ": ")
    q = 1 // (p + 1)
    s = -1
    for j in 0:p
        s *= -1
        coeff = q * s * binomial(p + 1, j) * bernoulli(j)
        iszero(coeff) && continue
        if iszero(j)
            print(coeff == 1 ? "" : coeff == -1 ? "-" : "$coeff")
        else
            print(coeff == 1 ? " + " : coeff == -1 ? " - " : coeff > 0 ? " + $coeff " : " - $(-coeff) ")
        end
        pwr = p + 1 - j
        if pwr > 1
            print("n", toexponent(pwr))
        else
            print("n")
        end
    end
    println()
end

end  # module Faulhaber
