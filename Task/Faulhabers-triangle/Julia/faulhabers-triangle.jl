function bernoulli(n)
    A = Vector{Rational{BigInt}}(undef, n + 1)
    for i in 0:n
        A[i + 1] = 1 // (i + 1)
        for j = i:-1:1
            A[j] = j * (A[j] - A[j + 1])
        end
    end
    return n == 1 ? -A[1] : A[1]
end

function faulhabercoeffs(p)
    coeffs = Vector{Rational{BigInt}}(undef, p + 1)
    q = Rational{BigInt}(1, p + 1)
    sign = -1
    for j in 0:p
        sign *= -1
        coeffs[p - j + 1] = bernoulli(j) * (q * sign) * Rational{BigInt}(binomial(p + 1, j), 1)
    end
    coeffs
end

faulhabersum(n, k) = begin coe = faulhabercoeffs(k); mapreduce(i -> BigInt(n)^i * coe[i], +, 1:k+1) end

prettyfrac(x) = (x.num == 0 ? "0" : x.den == 1 ? string(x.num) : replace(string(x), "//" => "/"))

function testfaulhaber()
    for i in 0:9
        for c in faulhabercoeffs(i)
            print(prettyfrac(c), "\t")
        end
        println()
    end
    println("\n", prettyfrac(faulhabersum(1000, 17)))
end

testfaulhaber()
