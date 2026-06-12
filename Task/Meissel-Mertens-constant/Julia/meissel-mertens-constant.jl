using Base.MathConstants  # sets constant γ = 0.5772156649015...
using Primes

""" Approximate the Meissel-Mertons constant. """
function meissel_mertens(iterations = 100_000_000)
    return mapreduce(p ->(d = 1/p; log(1 - d) + d), +, primes(prime(iterations))) + γ
end

@show meissel_mertens(100_000_000) # meissel_mertens(100000000) = 0.2614972128591237
