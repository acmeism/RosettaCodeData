mutable struct Point
	x::Float64
	y::Float64
end

Base.show(io::IO, p::Point) = print(io, "Point($(p.x), $(p.y))")

getx(p::Point) = p.x
gety(p::Point) = p.y

setx(p::Point, x) = (p.x = x)
sety(p::Point, y) = (p.y = y)

mutable struct Circle
	x::Float64
	y::Float64
	r::Float64
end

getx(c::Circle) = c.x
gety(c::Circle) = c.y
getr(c::Circle) = c.r

setx(c::Circle, x) = (c.x = x)
sety(c::Circle, y) = (c.y = y)
setr(c::Circle, r) = (c.r = r)

Base.show(io::IO, c::Circle) = print(io, "Circle($(c.x), $(c.y), $(c.r))")
