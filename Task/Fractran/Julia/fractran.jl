using .Iterators, BenchmarkTools
using Primes: Factorization, factor

# type alias for abbreviation
Factors = Factorization{Int}

# iterable stuct with parametric type polymorphism
struct Fractran{T}
    program::Vector{@NamedTuple{num::T, den::T}}
    input::Int

    # inner constructor
    function Fractran{T}(program::Vector{Rational{Int}}, input::Int) where T
        c = Dict(BigInt => identity, Factors => factor)[T]
        new{T}([(num = c(f.num), den = c(f.den)) for f ∈ program], input)
    end
end

# methods for Fractran with n::BigInt
Base.iterate(ft::Fractran{BigInt}, n = big(ft.input)) =
    for f ∈ ft.program
        if iszero(n % f.den)
            n = n ÷ f.den * f.num
            return n, n
        end
    end

iters(ft::Fractran{BigInt}) = ft

output(ft::Fractran{BigInt}) = (trailing_zeros(n) for n ∈ ft if ispow2(n))

# methods for Fractran with n::Factorization{Int}
Base.iterate(ft::Fractran{Factors}, n = factor(ft.input)) =
    for f ∈ ft.program
        if all(n[p] ≥ e for (p, e) ∈ f.den)
            for (p, e) ∈ f.den n[p] -= e end
            for (p, e) ∈ f.num n[p] += e end
            return n, n
        end
    end

iters(ft::Fractran{Factors}) = (prod(n) for n ∈ ft)

output(ft::Fractran{Factors}) = (n[2] for n ∈ ft if
    all((iszero(e) || (p == 2)) for (p, e) ∈ n))

# convenient Fractran scripting
macro ft_str(s::String)
    eval(Meta.parse(replace("[$s]", "/" => "//")))
end

# instantiation of Fractran example generating prime numbers
primes(T) = Fractran{T}(ft"17/91, 78/85, 19/51, 23/38, 29/33, 77/29,
    95/23, 77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1", 2)

# Output including Benchmark
ilim = 20; plim = 45

function printout(T)
    println("\n$ilim iterations and output of $plim prime numbers using ", T)
    println(join(take(iters(primes(T)), ilim), ", "), "…")
    join(stdout, take(output(primes(T)), plim), ", ")
    print("…\nBenchmark: $plim primes in")
end

printout(BigInt)
@btime collect(take(output(primes(BigInt)), plim))

printout(Factors)
@btime collect(take(output(primes(Factors)), plim));
