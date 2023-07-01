struct EgyptianFraction{T<:Integer} <: Real
    int::T
    frac::NTuple{N,Rational{T}} where N
end

Base.show(io::IO, ef::EgyptianFraction) = println(io, "[", ef.int, "] ", join(ef.frac, " + "))
Base.length(ef::EgyptianFraction) = !iszero(ef.int) + length(ef.frac)
function Base.convert(::Type{EgyptianFraction{T}}, fr::Rational) where T
    fr, int::T = modf(fr)
    fractions = Vector{Rational{T}}(0)
    x::T, y::T = numerator(fr), denominator(fr)
    iszero(x) && return EgyptianFraction{T}(int, (x // y,))
    while x != one(x)
        push!(fractions, one(T) // cld(y, x))
        x, y = mod1(-y, x), y * cld(y, x)
        d = gcd(x, y)
        x ÷= d
        y ÷= d
    end
    push!(fractions, x // y)
    return EgyptianFraction{T}(int, tuple(fractions...))
end
Base.convert(::Type{EgyptianFraction}, fr::Rational{T}) where T = convert(EgyptianFraction{T}, fr)
Base.convert(::Type{EgyptianFraction{T}}, fr::EgyptianFraction) where T = EgyptianFraction{T}(convert(T, fr.int), convert.(Rational{T}, fr.frac))
Base.convert(::Type{Rational{T}}, fr::EgyptianFraction) where T = T(fr.int) + sum(convert.(Rational{T}, fr.frac))
Base.convert(::Type{Rational}, fr::EgyptianFraction{T}) where T = convert(Rational{T}, fr)

@show EgyptianFraction(43 // 48)
@show EgyptianFraction{BigInt}(5 // 121)
@show EgyptianFraction(2014 // 59)

function task(fractions::AbstractVector)
    fracs = convert(Vector{EgyptianFraction{BigInt}}, fractions)
    local frlenmax::EgyptianFraction{BigInt}
    local lenmax = 0
    local frdenmax::EgyptianFraction{BigInt}
    local denmax = 0
    for f in fracs
        if length(f) ≥ lenmax
            lenmax = length(f)
            frlenmax = f
        end
        if denominator(last(f.frac)) ≥ denmax
            denmax = denominator(last(f.frac))
            frdenmax = f
        end
    end
    return frlenmax, lenmax, frdenmax, denmax
end

fr = collect((x // y) for x in 1:100 for y in 1:100 if x != y) |> unique
frlenmax, lenmax, frdenmax, denmax = task(fr)
println("Longest fraction, with length $lenmax: \n", Rational(frlenmax), "\n = ", frlenmax)
println("Fraction with greatest denominator\n(that is $denmax):\n", Rational(frdenmax), "\n = ", frdenmax)

println("\n# For 1 digit-integers:")
fr = collect((x // y) for x in 1:10 for y in 1:10 if x != y) |> unique
frlenmax, lenmax, frdenmax, denmax = task(fr)
println("Longest fraction, with length $lenmax: \n", Rational(frlenmax), "\n = ", frlenmax)
println("Fraction with greatest denominator\n(that is $denmax):\n", Rational(frdenmax), "\n = ", frdenmax)

println("# For 3 digit-integers:")
fr = collect((x // y) for x in 1:1000 for y in 1:1000 if x != y) |> unique
frlenmax, lenmax, frdenmax, denmax = task(fr)
println("Longest fraction, with length $lenmax: \n", Rational(frlenmax), "\n = ", frlenmax)
println("Fraction with greatest denominator\n(that is $denmax):\n", Rational(frdenmax), "\n = ", frdenmax)
