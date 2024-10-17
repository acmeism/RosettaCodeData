struct Point{T}
    x::T
    y::T
end

struct Line{T}
    s::Point{T}
    e::Point{T}
end

function intersection(l1::Line{T}, l2::Line{T}) where T<:Real
    a1 = l1.e.y - l1.s.y
    b1 = l1.s.x - l1.e.x
    c1 = a1 * l1.s.x + b1 * l1.s.y

    a2 = l2.e.y - l2.s.y
    b2 = l2.s.x - l2.e.x
    c2 = a2 * l2.s.x + b2 * l2.s.y

    Δ = a1 * b2 - a2 * b1
    # If lines are parallel, intersection point will contain infinite values
    return Point((b2 * c1 - b1 * c2) / Δ, (a1 * c2 - a2 * c1) / Δ)
end

l1 = Line(Point{Float64}(4, 0), Point{Float64}(6, 10))
l2 = Line(Point{Float64}(0, 3), Point{Float64}(10, 7))
println(intersection(l1, l2))

l1 = Line(Point{Float64}(0, 0), Point{Float64}(1, 1))
l2 = Line(Point{Float64}(1, 2), Point{Float64}(4, 5))
println(intersection(l1, l2))
