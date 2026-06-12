# Here is the matrix Fibonacci formula as specified to be used for the solution.
const b = [big"1" 1; 1 0]
matrixfibonacci(n) = n == 0 ? 0 : n == 1 ? 1 : (b^(n+1))[2,2]

# This exact Binet Fibonacci formula is not used due to BigFloat exponent size limitations.
binetfibonacci(n) = ((1+sqrt(big"5"))^n-(1-sqrt(big"5"))^n)/(sqrt(big"5")*big"2"^n)

# Use the exponent size limiting variant of the Binet formula seen in the Sidef example.
function firstbinet(bits, ndig=20)
    logφ =  big"2"^bits * log(10, (1 + sqrt(BigFloat(5.0))) / 2)
    mantissa = logφ - trunc(logφ) + ndig + 1
    return string(BigInt(round((10^mantissa - 10^(-mantissa)) / sqrt(BigFloat(5.0)))))[1:ndig]
end

# The fibmod function has no builtin in Julia, so here is one.
function fibmod(n::BigInt, nmod::BigInt)
    n < 2 && return n
    fibmods = Dict{BigInt, BigInt}()
    function f(n::BigInt)
        n < 2 && return 1
        haskey(fibmods, n) && return fibmods[n]
        k = div(n, 2)
        fibmods[n] = iseven(n) ?
            (f(k) * f(k) + f(k - 1) * f(k - 1)) % nmod :
            (f(k) * f(k + 1) + f(k - 1) * f(k)) % nmod
    end
    f(n - 1)
end
lastfibmod(bits, ndig=21) = string(fibmod(big"2"^bits, big"10"^(ndig+1)))

# See Wikipedia on Lucas function for the algorithm below.
#  inner -> F(n/2), F(n/2 - 1), L(n) = F(n) + 2F(n-1), and L(n/2) * F(n/2) = F(n)
function lucasfibonacci(n)
    function inner(n)
        if n == 0
            return big"0", big"1"
        end
        u, v = inner(n >> 1)
        q = (n & 2) - 1
        u *= u
        v *= v
        return isodd(n) ? (BigInt(u + v), BigInt(3 * v - 2 * (u - q))) :
            (BigInt(2 * (v + q) - 3 * u), BigInt(u + v))
    end
    u, v = inner(n >> 1)
    l = 2*v - u # the lucas function
    if isodd(n)
        q = (n & 2) - 1
        return v * l + q
    end
    return u * l
end

m2s(bits) = string(matrixfibonacci(big"2"^bits))
l2s(bits) = string(lucasfibonacci(big"2"^bits))
firstlast(s) = (length(s) < 40 ? s : s[1:20] * "..." * s[end-20+1:end])

println("N", " "^23, "Matrix", " "^40, "Lucas", " "^40, "Mod\n", "-"^145)
println("2^16  ", rpad(firstlast(m2s(16)), 45), rpad(firstlast(l2s(16)), 45),
    rpad(firstlast(firstbinet(16) * lastfibmod(16)), 45))
println("2^32  ", rpad(firstlast(m2s(32)), 45), rpad(firstlast(l2s(32)), 45),
    rpad(firstlast(firstbinet(32) * lastfibmod(32)), 45))
println("2^64  ", " "^90, rpad(firstlast(firstbinet(64) * lastfibmod(64)), 45))
