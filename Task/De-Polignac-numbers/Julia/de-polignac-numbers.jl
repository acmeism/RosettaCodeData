using Primes
using Printf

function isdepolignac(n::Integer)
    iseven(n) && return false

    twopows = Iterators.map(x -> 2^x, 0:floor(Int, log2(n)))

    return !any(twopows) do twopow
        isprime(n - twopow)
    end
end

function depolignacs()
    naturals = Iterators.countfrom()
    return Iterators.filter(isdepolignac, naturals)
end


for (i, dep) in Iterators.enumerate(depolignacs())
    if i == 1
        println("The first 50 de Polignac numbers:")
    end

    if i <= 50
        @printf "%4d" dep
        i % 10 == 0 ? println() : print(" ")
    end

    if i == 50
        println()
    end

    if i == 1000
        println("The 1000th de Polignac number is $dep")
        println()
    end

    if i == 10000
        println("The 10000th de Polignac number is $dep")
        break
    end
end


