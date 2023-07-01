struct Modulo{T<:Integer} <: Integer
    val::T
    mod::T
    Modulo(n::T, m::T) where T = new{T}(mod(n, m), m)
end
modulo(n::Integer, m::Integer) = Modulo(promote(n, m)...)

Base.show(io::IO, md::Modulo) = print(io, md.val, " (mod $(md.mod))")
Base.convert(::Type{T}, md::Modulo) where T<:Integer = convert(T, md.val)
Base.copy(md::Modulo{T}) where T = Modulo{T}(md.val, md.mod)

Base.:+(md::Modulo) = copy(md)
Base.:-(md::Modulo) = Modulo(md.mod - md.val, md.mod)
for op in (:+, :-, :*, :÷, :^)
    @eval function Base.$op(a::Modulo, b::Integer)
        val = $op(a.val, b)
        return Modulo(mod(val, a.mod), a.mod)
    end
    @eval Base.$op(a::Integer, b::Modulo) = $op(b, a)
    @eval function Base.$op(a::Modulo, b::Modulo)
        if a.mod != b.mod throw(InexactError()) end
        val = $op(a.val, b.val)
        return Modulo(mod(val, a.mod), a.mod)
    end
end

f(x) = x ^ 100 + x + 1
@show f(modulo(10, 13))
