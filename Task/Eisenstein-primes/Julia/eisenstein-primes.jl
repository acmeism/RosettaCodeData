""" rosettacode.org/wiki/Eisenstein_primes """

import Base: Complex, real, imag
import LinearAlgebra: norm
import Primes: isprime
import Plots: scatter

struct Eisenstein{T<:Integer} <: Number
    a::T
    b::T
    Eisenstein(a::T, b::T) where {T} = new{T}(a, b)
    Eisenstein(a::T) where {T<:Integer} = new{T}(a, zero(T))
    Eisenstein(a::Integer, b::Integer) = new{eltype(promote(a, b))}(promote(a, b)...)
end

const ω = Eisenstein(false, true)

real(n::Eisenstein) = n.a - n.b / 2

imag(n::Eisenstein) = n.b * sqrt(big(3.0)) / 2

norm(n::Eisenstein) = n.a * n.a + n.b * n.b - n.a * n.b

Complex(n::Eisenstein{T}) where {T} = Complex{typeof(real(n))}(real(n), imag(n))

"""
    is_eisenstein_prime(n)

An Eisenstein integer is a non-unit Gaussian integer a + bω where ω(1+ω) = -1,
and a and b are integers. As a Gaussian integer, any Eisenstein integer is
either a unit (an integer with a multiplicative inverse [±1, ±ω, ±(ω^-1)]),
prime (a number p such that if p divides xy, then p necessarily divides
either x or y), or composite (a product of primes).

    An Eisenstein integer a + bω is a prime if either it is a product of a unit
and an integer prime p such that p % 3 == 2 or norm(a + bω) is an integer prime.
"""
function is_eisenstein_prime(n::Eisenstein)
    if n.a == 0 || n.b == 0 || n.a == n.b
        c = max(abs(n.a), abs(n.b))
        return isprime(c) && c % 3 == 2
    else
        return isprime(norm(n))
    end
end

function test_eisenstein_primes(graphlimitsquared = 10_000, printlimit = 100)
    lim = isqrt(graphlimitsquared)
    arr = [Eisenstein(a, b) for a = -lim:lim, b = -lim:lim]
    eprimes = sort!(filter(is_eisenstein_prime, arr), lt = (x, y) -> norm(x) < norm(y)))
    for (i, c) in enumerate(eprimes)
        if i <= printlimit
            print(lpad(round(Complex(c), digits = 4), 18), i % 5 == 0 ? "\n" : "")
        end
    end
    display(
        scatter(
            map(real, eprimes),
            map(imag, eprimes),
            markersize = 1,
            title = "Eisenstein primes with norm < $lim",
        ),
    )
end

test_eisenstein_primes()
