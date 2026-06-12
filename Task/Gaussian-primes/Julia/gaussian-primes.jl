using LinearAlgebra
using Plots
using Primes

"""
    function isGaussianprime(n::Complex{T}) where T <: Integer

A Gaussian prime is a non-unit Gaussian integer m + ni divisible only by its associates and by the units
1, i, -1, -i and by no other Gaussian integers.

The Gaussian primes fall into one of three categories:

Gaussian integers with imaginary part zero and a prime real part m with |m| a real prime satisfying |m| = 3 mod 4
Gaussian integers with real part zero and an imaginary part n with |n| real prime satisfying  |n| = 3 mod 4
Gaussian integers having both real and imaginary parts, and its complex norm (square of algebraic norm) is a real prime number
"""
function isGaussianprime(n::Complex{T}) where T <: Integer
    r, c = abs(real(n)), abs(imag(n))
    return isprime(r * r + c * c) || c == 0 && isprime(r) && (r - 3) % 4 == 0 || r == 0 && isprime(c) && (c - 3) % 4 == 0
end

function testgaussprimes(lim = 10)
    testvals = map(c -> c[1] + im * c[2], collect(Iterators.product(-lim:lim, -lim:lim)))
    gprimes = sort!(filter(c -> isGaussianprime(c) && norm(c) < lim, testvals), by = norm)
    println("Gaussian primes within $lim of the origin on the complex plane:")
    foreach(p -> print(lpad(p[2], 10), p[1] % 10 == 0 ? "\n" : ""), enumerate(gprimes)) # print
    testvals50 = map(c -> c[1] + im * c[2], collect(Iterators.product(-50:50, -50:50)))
    gprimes50 = sort!(filter(c -> isGaussianprime(c) && norm(c) < 50, testvals50), by = norm)
    scatter(gprimes50)  # plot
end

testgaussprimes()
