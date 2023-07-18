# FRACTRAN interpreter implemented as an iterable struct

using .Iterators: filter, map, take

struct Fractran
    rs::Vector{Rational{BigInt}}
    i₀::BigInt
    limit::Int
end

Base.iterate(f::Fractran, i = f.i₀) =
    for r in f.rs
        if iszero(i % r.den)
            i = i ÷ r.den * r.num
            return i, i
        end
    end

interpret(f::Fractran) =
    take(
        map(trailing_zeros,
            filter(ispow2, f))
        f.limit)

Base.show(io::IO, f::Fractran) =
    join(io, interpret(f), ' ')

macro code_str(s)
   [eval(Meta.parse(replace(t, "/" => "//"))) for t ∈ split(s)]
end

primes = Fractran(code"17/91 78/85 19/51 23/38 29/33 77/29 95/23
        77/19 1/17 11/13 13/11 15/14 15/2 55/1", 2, 30)

# Output
println("First 25 iterations of FRACTRAN program 'primes':\n2 ",
    join(take(primes, 25), ' '))

println("\nWatch the first 30 primes dropping out within seconds:")

primes
