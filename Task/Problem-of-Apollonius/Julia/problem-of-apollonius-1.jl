module ApolloniusProblems

using Polynomials, LinearAlgebra, Printf
export Circle

struct Point{T<:Real}
    x::T
    y::T
end

xcoord(p::Point) = p.x
ycoord(p::Point) = p.y

struct Circle{T<:Real}
    c::Point{T}
    r::T
end
Circle(x::T, y::T, r::T) where T<:Real = Circle(Point(x, y), r)

radius(c::Circle) = c.r
center(c::Circle) = c.c
xcenter(c::Circle) = xcoord(center(c))
ycenter(c::Circle) = ycoord(center(c))

Base.show(io::IO, c::Circle) =
    @printf(io, "centered at (%0.4f, %0.4f) with radius %0.4f",
        xcenter(c), ycenter(c), radius(c))

function solve(ap::Vector{Circle{T}}, enc=()) where T<:Real
    length(ap) == 3 || error("This Apollonius problem needs 3 circles.")
    x = @. xcenter(ap)
    y = @. ycenter(ap)
    r = map(u -> ifelse(u ∈ enc, -1, 1), 1:3) .* radius.(ap)
    @views begin
        a = 2x[1] .- 2x[2:3]
        b = 2y[1] .- 2y[2:3]
        c = 2r[1] .- 2r[2:3]
        d = (x[1] ^ 2 + y[1] ^ 2 - r[1] ^ 2) .- (x[2:3] .^ 2 .+ y[2:3] .^ 2 .- r[2:3] .^ 2)
    end
    u = Polynomial([-det([b d]), det([b c])] ./ det([a b]))
    v = Polynomial([det([a d]), -det([a c])] ./ det([a b]))
    w = Polynomial([r[1], 1.0]) ^ 2
    s = (u - x[1]) ^ 2 + (v - y[1]) ^ 2 - w
    r = filter(x -> iszero(imag(x)) && x > zero(x), roots(s))
    length(r) <  2 || error("The solution is not unique.")
    length(r) == 1 || error("There is no solution.")
    r = r[1]
    return Circle(evalpoly(r, u), evalpoly(r, v), r)
end

end  # module ApolloniusProblem
