module FormalPowerSeries

using Printf
import Base.iterate, Base.eltype, Base.one, Base.show, Base.IteratorSize
import Base.IteratorEltype, Base.length, Base.size, Base.convert

_div(a, b) = a / b
_div(a::Union{Integer,Rational}, b::Union{Integer,Rational}) = a // b

abstract type AbstractFPS{T<:Number} end

Base.IteratorSize(::AbstractFPS) = Base.IsInfinite()
Base.IteratorEltype(::AbstractFPS) = Base.HasEltype()
Base.eltype(::AbstractFPS{T}) where T = T
Base.one(::AbstractFPS{T}) where T = ConstantFPS(one(T))

function Base.show(io::IO, fps::AbstractFPS{T}) where T
    itr = Iterators.take(fps, 8)
    a, s = iterate(itr)
    print(io, a)
    a, s = iterate(itr, s)
    @printf(io, " %s %s⋅x",
        ifelse(sign(a) ≥ 0, '+', '-'), abs(a))
    local i = 2
    while (it = iterate(itr, s)) != nothing
        a, s = it
        @printf(io, " %s %s⋅x^%i",
            ifelse(sign(a) ≥ 0, '+', '-'), abs(a), i)
        i += 1
    end
    print(io, "...")
end

struct MinusFPS{T,A<:AbstractFPS{T}} <: AbstractFPS{T}
    a::A
end
Base.:-(a::AbstractFPS{T}) where T = MinusFPS{T,typeof(a)}(a)

function Base.iterate(fps::MinusFPS)
	v, s = iterate(fps.a)
	return -v, s
end
function Base.iterate(fps::MinusFPS, st)
    v, s = iterate(fps.a, st)
    return -v, s
end

struct SumFPS{T,A<:AbstractFPS,B<:AbstractFPS} <: AbstractFPS{T}
    a::A
    b::B
end
Base.:+(a::AbstractFPS{A}, b::AbstractFPS{B}) where {A,B} =
    SumFPS{promote_type(A, B),typeof(a),typeof(b)}(a, b)
Base.:-(a::AbstractFPS, b::AbstractFPS) = a + (-b)

function Base.iterate(fps::SumFPS{T,A,B}) where {T,A,B}
    a1, s1 = iterate(fps.a)
    a2, s2 = iterate(fps.b)
    return T(a1 + a2), (s1, s2)
end
function Base.iterate(fps::SumFPS{T,A,B}, st) where {T,A,B}
    stateA, stateB = st
    valueA, stateA = iterate(fps.a, stateA)
    valueB, stateB = iterate(fps.b, stateB)
    return T(valueA + valueB), (stateA, stateB)
end

struct ProductFPS{T,A<:AbstractFPS,B<:AbstractFPS} <: AbstractFPS{T}
    a::A
    b::B
end
Base.:*(a::AbstractFPS{A}, b::AbstractFPS{B}) where {A,B} =
    ProductFPS{promote_type(A, B),typeof(a),typeof(b)}(a, b)

function Base.iterate(fps::ProductFPS{T}) where T
    a1, s1 = iterate(fps.a)
    a2, s2 = iterate(fps.b)
    T(sum(a1 .* a2)), (s1, s2, T[a1], T[a2])
end
function Base.iterate(fps::ProductFPS{T,A,B}, st) where {T,A,B}
    stateA, stateB, listA, listB = st
    valueA, stateA = iterate(fps.a, stateA)
    valueB, stateB = iterate(fps.b, stateB)
    push!(listA, valueA)
    pushfirst!(listB, valueB)
    return T(sum(listA .* listB)), (stateA, stateB, listA, listB)
end

struct DifferentiatedFPS{T,A<:AbstractFPS} <: AbstractFPS{T}
    a::A
end
differentiate(fps::AbstractFPS{T}) where T = DifferentiatedFPS{T,typeof(fps)}(fps)

function Base.iterate(fps::DifferentiatedFPS{T,A}) where {T,A}
    _, s = iterate(fps.a)
    return Base.iterate(fps, (zero(T), s))
end
function Base.iterate(fps::DifferentiatedFPS{T,A}, st) where {T,A}
    n, s = st
    n += one(n)
    v, s = iterate(fps.a, s)
    return n * v, (n, s)
end

struct IntegratedFPS{T,A<:AbstractFPS} <: AbstractFPS{T}
    a::A
    k::T
end
integrate(fps::AbstractFPS{T}, k::T=zero(T)) where T = IntegratedFPS{T,typeof(fps)}(fps, k)
integrate(fps::AbstractFPS{T}, k::T=zero(T)) where T <: Integer =
    IntegratedFPS{Rational{T},typeof(fps)}(fps, k)

function Base.iterate(fps::IntegratedFPS{T,A}, st=(0, 0)) where {T,A}
	if st == (0, 0)
		return fps.k, (one(T), 0)
	end
    n, s = st
    if n == one(T)
		v, s = iterate(fps.a)
	else
		v, s = iterate(fps.a, s)
	end
    r::T = _div(v, n)
    n += one(n)
    return r, (n, s)
end

# Examples of FPS: constant

struct FiniteFPS{T} <: AbstractFPS{T}
    v::NTuple{N,T} where N
end
Base.iterate(fps::FiniteFPS{T}, st=1) where T =
    st > lastindex(fps.v) ? (zero(T), st) : (fps.v[st], st + 1)
Base.convert(::Type{FiniteFPS}, x::Real) = FiniteFPS{typeof(x)}((x,))
FiniteFPS(r) = convert(FiniteFPS, r)
for op in (:+, :-, :*)
    @eval Base.$op(x::Number, a::AbstractFPS) = $op(FiniteFPS(x), a)
    @eval Base.$op(a::AbstractFPS, x::Number) = $op(a, FiniteFPS(x))
end

struct ConstantFPS{T} <: AbstractFPS{T}
    k::T
end
Base.iterate(c::ConstantFPS, ::Any=nothing) = c.k, nothing

struct SineFPS{T} <: AbstractFPS{T} end
SineFPS() = SineFPS{Rational{Int}}()
function Base.iterate(::SineFPS{T}, st=(0, 1, 1)) where T
    n, fac, s = st
    local r::T
    if iseven(n)
        r = zero(T)
    else
        r = _div(one(T), (s * fac))
        s = -s
    end
    n += 1
    fac *= n
    return r, (n, fac, s)
end

struct CosineFPS{T} <: AbstractFPS{T} end
CosineFPS() = CosineFPS{Rational{Int}}()
function Base.iterate(::CosineFPS{T}, st=(0, 1, 1)) where T
    n, fac, s = st
    local r::T
    if iseven(n)
        r = _div(one(T), (s * fac))
    else
        r = zero(T)
        s = -s
    end
    n += 1
    fac *= n
    return r, (n, fac, s)
end

end  # module FormalPowerSeries
