using Primes, Polynomials

# memoize cache for recursive calls
const cyclotomics = Dict([1 => Poly([big"-1", big"1"]), 2 => Poly([big"1", big"1"])])

# get all integer divisors of an integer, except itself
function divisors(n::Integer)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p^j for j in 1:e], init=f)
    end
    return resize!(f, length(f) - 1)
end

"""
    cyclotomic(n::Integer)

Calculate the n -th cyclotomic polynomial.
See wikipedia article at bottom of section /wiki/Cyclotomic_polynomial#Fundamental_tools
The algorithm is reliable but slow for large n > 1000.
"""
function cyclotomic(n::Integer)
    if haskey(cyclotomics, n)
        c = cyclotomics[n]
    elseif isprime(n)
        c = Poly(ones(BigInt, n))
        cyclotomics[n] = c
    else  # recursive formula seen in wikipedia article
        c = Poly([big"-1"; zeros(BigInt, n - 1); big"1"])
        for d in divisors(n)
            c ÷= cyclotomic(d)
        end
        cyclotomics[n] = c
    end
    return c
end

println("First 30 cyclotomic polynomials:")
for i in 1:30
    println(rpad("$i:  ", 5), cyclotomic(BigInt(i)))
end

const dig = zeros(BigInt, 10)
for i in 1:1000000
    if all(x -> x != 0, dig)
        break
    end
    for coef in coeffs(cyclotomic(i))
        x = abs(coef)
        if 0 < x < 11 && dig[Int(x)] == 0
            dig[Int(x)] = coef < 0 ? -i : i
        end
    end
end
for (i, n) in enumerate(dig)
    println("The cyclotomic polynomial Φ(", abs(n), ") has a coefficient that is ", n < 0 ? -i : i)
end
