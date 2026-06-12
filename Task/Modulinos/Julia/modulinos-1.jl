module Divisors

using Primes

export properdivisors

function properdivisors(n::T) where T <: Integer
    0 < n || throw(ArgumentError("number to be factored must be ≥ 0, got $n"))
    1 < n || return T[]
    !isprime(n) || return T[one(T), n]
    f = factor(n)
    d = T[one(T)]
    for (k, v) in f
        c = T[k^i for i in 0:v]
        d = d*c'
        d = reshape(d, length(d))
    end
    sort!(d)
    return d[1:end-1]
end

function interactiveDivisors()
    println("\nFind proper divisors between two numbers.\nFirst number: ")
    lo = (x = tryparse(Int64, readline())) == nothing ? 0 : x
    println("\nSecond number: ")
    hi = (x = tryparse(Int64, readline())) == nothing ? 10 : x
    lo, hi = lo > hi ? (hi, lo) : (lo, hi)

    println("Listing the proper divisors for $lo through $hi.")
    for i in lo:hi
        println(lpad(i, 7), "  =>  ", rpad(properdivisors(i), 10))
    end
end

end

# some testing code
if occursin(r"divisors.jl"i, Base.PROGRAM_FILE)
    println("This module is running as main.\n")
    Divisors.interactiveDivisors()
end
