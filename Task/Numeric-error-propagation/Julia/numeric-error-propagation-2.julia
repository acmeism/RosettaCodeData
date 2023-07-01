module NumericError

import Base: convert, promote_rule, +, -, *, /, ^

export Measure

type Measure <: Number
  x::Float64
  σ::Float64
  Measure(x::Real) = new(Float64(x), 0)
  Measure(x::Real, σ::Real) = new(Float64(x), σ)
end

Base.show(io::IO, x::Measure) = print(io, string(x.x, " ± ", x.σ))

Base.convert(::Type{Measure}, x::Real) = Measure(Float64(x), 0.0)
Base.promote_rule(::Type{Float64}, ::Type{Measure}) = Measure
Base.promote_rule(::Type{Int64}, ::Type{Measure}) = Measure

+(a::Measure, b::Measure) = Measure(a.x + b.x, sqrt(a.σ ^ 2 + b.σ ^ 2))
-(a::Measure, b::Measure) = Measure(a.x - b.x, sqrt(a.σ ^ 2 + b.σ ^ 2))
-(a::Measure) = Measure(-a.x, a.σ)

*(a::Measure, b::Measure) = begin
  x = a.x * b.x
  σ = sqrt(x ^ 2 * ((a.σ / a.x) ^ 2 + (b.σ / b.x) ^ 2))
  Measure(x, σ)
end
/(a::Measure, b::Measure) = begin
  x = a.x / b.x
  σ = sqrt(x ^ 2 * ((a.σ / a.x) ^ 2 + (b.σ / b.x) ^ 2))
  Measure(x, σ)
end

^(a::Measure, b::Float64) = begin
  x = a.x ^ b
  σ = abs(x * b * a.σ / a.x)
  Measure(x, σ)
end

Base.sqrt(a::Measure) = a ^ .5

end  # module NumericError

using NumericError

# x1 = 100 ± 1.1
# y1 = 50 ± 1.2
# x2 = 200 ± 2.2
# y2 = 100 ± 2.3

x1 = Measure(100, 1.1)
y1 = Measure(50,  1.2)
x2 = Measure(200, 2.2)
y2 = Measure(100, 2.3)

d = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)

@show x1 y1 x2 y2 sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
