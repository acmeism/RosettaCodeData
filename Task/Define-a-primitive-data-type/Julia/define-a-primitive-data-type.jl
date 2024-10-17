struct LittleInt <: Integer
    val::Int8
    function LittleInt(n::Real)
        1 ≤ n ≤ 10 || throw(ArgumentError("LittleInt number must be in [1, 10]"))
        return new(Int8(n))
    end
end
Base.show(io::IO, x::LittleInt) = print(io, x.val)
Base.convert(::Type{T}, x::LittleInt) where T<:Number = convert(T, x.val)
Base.promote_rule(::Type{LittleInt}, ::Type{T}) where T<:Number = T

for op in (:+, :*, :÷, :-, :&, :|, :$, :<, :>, :(==))
    @eval (Base.$op)(a::LittleInt, b::LittleInt) = LittleInt(($op)(a.val, b.val))
end

# Test
a = LittleInt(3)
b = LittleInt(4.0)
@show a b
@show a + b
@show b - a
@show a * LittleInt(2)
@show b ÷ LittleInt(2)
@show a * b
