import LinearAlgebra: dot

const Vector2 = Tuple{Float64, Float64}
const Projection = NamedTuple{(:min, :max), NTuple{2, Float64}}
const Polygon = Vector{Vector2}
const Rectangle = NamedTuple{(:x, :y, :w, :h), NTuple{4, Float64}}

function axes(poly::Polygon)::Polygon
	result = [(0.0, 0.0) for _ in eachindex(poly)]
	for (i, vertex1) in enumerate(poly)
		vertex2 = i == lastindex(poly) ? first(poly) : poly[i+1] # wraps around
		edge = (first(vertex1) - first(vertex2), last(vertex1) - last(vertex2))
		result[i] = (-last(edge), first(edge))
	end
	return result
end

function projectiononaxis(poly::Polygon, axis::Vector2)::Projection
	resultmin, resultmax = Inf, -Inf
	for vertex in poly
		p = dot(axis, vertex)
		p < resultmin && (resultmin = p)
		p > resultmax && (resultmax = p)
	end
	return Projection((resultmin, resultmax))
end

projectionoverlaps(p1::Projection, p2::Projection) = p1[2] <= p2[1] && p2[2] >= p1[1]

Polygon(r::Rectangle) = [(r.x, r.y), (r.x, r.y + r.h), (r.x + r.w, r.y + r.h), (r.x + r.w, r.y)]

function polygonoverlapsrect(p1::Polygon, rect::Rectangle)::Bool
	p2 = Polygon(rect)
	return !any(projectionoverlaps(projectiononaxis(p1, axis), projectiononaxis(p2, axis))
				for a in [axes(p1), axes(p2)] for axis in a)
end

const poly = [(0.0, 0.0), (0.0, 2.0), (1.0, 4.0), (2.0, 2.0), (2.0, 0.0)]
const rect1 = Rectangle((4.0, 0.0, 2.0, 2.0))
const rect2 = Rectangle((1.0, 0.0, 8.0, 2.0))
println("poly = a polygon with vertices: ", poly)
println("rect1 = Rectangle with ", rect1)
println("rect2 = Rectangle with ", rect2)
println("\npoly and rect1 overlap? ", polygonoverlapsrect(poly, rect1))
println("poly and rect2 overlap? ", polygonoverlapsrect(poly, rect2))
