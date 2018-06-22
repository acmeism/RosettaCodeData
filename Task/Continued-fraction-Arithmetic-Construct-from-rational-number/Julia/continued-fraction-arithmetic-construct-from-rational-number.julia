# It'st most appropriate to define a Julia iterable object for this task
# Julia doesn't have Python'st yield, the closest to it is produce/consume calls with Julia tasks
# but for various reasons they don't work out for this task
# This solution works with two integers, a Julia rational or a real

mutable struct ContinuedFraction{T<:Integer}
    n1::T # numerator or real
    n2::T # denominator or 1 if real
    t1::T # generated coefficient
end

# Constructors for all possible input types
ContinuedFraction{T<:Integer}(n1::T, n2::T) = ContinuedFraction(n1, n2, 0)
ContinuedFraction(n::Rational) = ContinuedFraction(numerator(n), denominator(n))
ContinuedFraction(n::AbstractFloat) = ContinuedFraction(Rational(n))

# Methods to make our object iterable
Base.start(::ContinuedFraction) = nothing
# Returns true if we've prepared the continued fraction
Base.done(cf::ContinuedFraction, st) = cf.n2 == 0
# Generates the next coefficient
function Base.next(cf::ContinuedFraction, st)
    cf.n1, (cf.t1, cf.n2) = cf.n2, divrem(cf.n1, cf.n2)
    return cf.t1, nothing
end

# Tell Julia that this object always returns ints (all coeffs are integers)
Base.eltype{T}(::Type{ContinuedFraction{T}}) = T

# Overload the default collect function so that we can collect the first maxiter coeffs of infinite continued fractions
# array slicing doesn't work as Julia crashes before the slicing due to our infinitely long array
function Base.collect(itr::ContinuedFraction, maxiter::Integer = 100)
    r = Array{eltype(itr)}(maxiter)
    i = 1
    for v in itr
        r[i] = v
        i += 1
        if i > maxiter break end
    end
    return r[1:i-1]
end

# Test cases according to task description with outputs in comments
println(collect(ContinuedFraction(1, 2)))       # => [0, 2]
println(collect(ContinuedFraction(3, 1)))       # => [3]
println(collect(ContinuedFraction(23, 8)))      # => [2, 1, 7]
println(collect(ContinuedFraction(13, 11)))     # => [1, 5, 2]
println(collect(ContinuedFraction(22, 7)))      # => [3, 7]
println(collect(ContinuedFraction(14142, 10000)))       # => [1, 2, 2, 2, 2, 2, 1, 1, 29]
println(collect(ContinuedFraction(141421, 100000)))     # => [1, 2, 2, 2, 2, 2, 2, 3, 1, 1, 3, 1, 7, 2]
println(collect(ContinuedFraction(1414214, 1000000)))   # => [1, 2, 2, 2, 2, 2, 2, 2, 3, 6, 1, 2, 1, 12]
println(collect(ContinuedFraction(14142136, 10000000))) # => [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 1, 2, 4, 1, 1, 2]

println(collect(ContinuedFraction(13 // 11)))   # => [1, 5, 2]
println(collect(ContinuedFraction(√2), 20))     # => [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
