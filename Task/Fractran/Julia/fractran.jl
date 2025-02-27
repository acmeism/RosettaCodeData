using Base.Iterators: filter, map, take
using Dates: now, seconds

struct FRACTRAN
    P::Vector{Rational{BigInt}}
    i::BigInt
end

# a new method for the builtin function 'iterate' to make the Fractran program run
Base.iterate(ft::FRACTRAN, n = ft.i) =
    for f in ft.P
        if iszero(n % f.den)
            n = n ÷ f.den * f.num
            return n, n
        end
    end

"lazy generation of Fractran output sequence"
out(ft::FRACTRAN) = map(trailing_zeros, filter(ispow2, ft))

"convenient Fractran scripting"
macro P_str(s) eval(Meta.parse(replace("[$s]", "/" => "//"))) end

primes = FRACTRAN(P"17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23, 77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1", 2)

println("2, ", join(take(primes, 20), ", "), "...")
t = now()
join(stdout, take(out(primes), 25), ", ")
println("...\n25 primes in $(seconds(now() - t)) seconds")
