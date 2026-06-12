using Random

# Define the Point struct
struct Point
    x::Float64
    y::Float64
end

# Define comparison operators for Point
Base.:(==)(p1::Point, p2::Point) = p1.x == p2.x && p1.y == p2.y
Base.isless(p1::Point, p2::Point) = p1.x == p2.x ? p1.y < p2.y : p1.x < p2.x

# Function to flip points
flipped(points::Vector{Point})::Vector{Point} = [Point(-p.x, -p.y) for p in points]

# Quickselect for types implementing isless
function quickselect!(ls::Vector{T}, index::Int, lo::Int = 1, hi::Union{Int, Nothing} = nothing)::T where T
    hi = isnothing(hi) ? length(ls) : hi

    lo == hi && return ls[lo]

    pivot = lo + rand(0:(hi-lo))
    ls[lo], ls[pivot] = ls[pivot], ls[lo]

    cur = lo
    for run in (lo+1):hi
        if ls[run] < ls[lo]
            cur += 1
            ls[cur], ls[run] = ls[run], ls[cur]
        end
    end

    ls[cur], ls[lo] = ls[lo], ls[cur]

    if index < cur
        return quickselect!(ls, index, lo, cur - 1)
    elseif index > cur
        return quickselect!(ls, index, cur + 1, hi)
    else
        return ls[cur]
    end
end

# Bridge function to find the upper bridge of the convex hull
function bridge(points::Set{Point}, vertical_line::Float64)::Tuple{Point, Point}
    candidates = Set{Point}()

    if length(points) == 2
        p = collect(points)
        return (p[1], p[2])
    end

    pairs = Vector{Tuple{Point, Point}}()
    modify_s = copy(points)

    while length(modify_s) >= 2
        p1 = pop!(modify_s)
        p2 = pop!(modify_s)

        if p1 < p2
            push!(pairs, (p1, p2))
        else
            push!(pairs, (p2, p1))
        end
    end

    if !isempty(modify_s)
        push!(candidates, first(modify_s))
    end

    slopes = Vector{Float64}()
    i = 1
    while i <= length(pairs)
        pi, pj = pairs[i]

        if pi.x == pj.x
            push!(candidates, pi.y > pj.y ? pi : pj)
            deleteat!(pairs, i)
        else
            push!(slopes, (pi.y - pj.y) / (pi.x - pj.x))
            i += 1
        end
    end

    if isempty(slopes)
        if length(candidates) >= 2
            c = collect(candidates)[1:2]
            return (c[1], c[2])
        end
        p = collect(points)[1:2]
        return (p[1], p[2])
    end

    median_index = div(length(slopes), 2) - (length(slopes) % 2 == 0 ? 1 : 0) + 1
    slopes_copy = copy(slopes)
    median_slope = quickselect!(slopes_copy, median_index)

    small = Vector{Tuple{Point, Point}}()
    equal = Vector{Tuple{Point, Point}}()
    large = Vector{Tuple{Point, Point}}()

    for i in 1:length(slopes)
        if slopes[i] < median_slope
            push!(small, pairs[i])
        elseif abs(slopes[i] - median_slope) < eps(Float64)
            push!(equal, pairs[i])
        else
            push!(large, pairs[i])
        end
    end

    max_slope = -Inf
    for point in points
        max_slope = max(max_slope, point.y - median_slope * point.x)
    end

    max_set = [point for point in points if abs(point.y - median_slope * point.x - max_slope) < eps(Float64)]

    left = minimum(max_set)
    right = maximum(max_set)

    if left.x <= vertical_line && right.x > vertical_line
        return (left, right)
    end

    if right.x <= vertical_line
        for (_, p2) in large
            push!(candidates, p2)
        end
        for (_, p2) in equal
            push!(candidates, p2)
        end
        for (p1, p2) in small
            push!(candidates, p1)
            push!(candidates, p2)
        end
    end

    if left.x > vertical_line
        for (p1, _) in small
            push!(candidates, p1)
        end
        for (p1, _) in equal
            push!(candidates, p1)
        end
        for (p1, p2) in large
            push!(candidates, p1)
            push!(candidates, p2)
        end
    end

    bridge(candidates, vertical_line)
end

# Connect function to build the hull between two points
function connect(lower::Point, upper::Point, points::Set{Point})::Vector{Point}
    if lower == upper
        return [lower]
    end

    points_vec = collect(points)
    mid_index = div(length(points_vec), 2)

    max_left = quickselect!(copy(points_vec), mid_index)
    min_right = quickselect!(copy(points_vec), mid_index + 1)

    left, right = bridge(points, (max_left.x + min_right.x) / 2.0)

    points_left = Set([left])
    points_right = Set([right])

    for point in points
        if point.x < left.x
            push!(points_left, point)
        elseif point.x > right.x
            push!(points_right, point)
        end
    end

    left_result = connect(lower, left, points_left)
    right_result = connect(right, upper, points_right)

    return vcat(left_result, right_result)
end

# Compute the upper hull
function upper_hull(points::Set{Point})::Vector{Point}
    points_vec = collect(points)
    lower = minimum(points_vec)

    # Find the lowest point with the same x-coordinate as the minimum
    for point in points
        if point.x == lower.x && point.y > lower.y
            lower = point
        end
    end

    upper = maximum(points_vec)

    filtered_points = Set([lower, upper])
    for p in points
        if lower.x < p.x < upper.x
            push!(filtered_points, p)
        end
    end

    return connect(lower, upper, filtered_points)
end

# Compute the convex hull
function convex_hull(points::Set{Point})::Vector{Point}
    upper = upper_hull(points)

    flipped_points = Set([Point(-p.x, -p.y) for p in points])
    flipped_upper = upper_hull(flipped_points)
    lower = flipped(flipped_upper)

    result = copy(upper)

    if !isempty(result) && !isempty(lower) && result[end] == lower[1]
        lower = lower[2:end]
    end

    if !isempty(result) && !isempty(lower) && result[1] == lower[end]
        lower = lower[1:end-1]
    end

    return vcat(result, lower)
end

# Main function to test the convex hull
function testks()
    # Create points for a 2D projection of a 3D simplex
    points = Set([
        Point(0.0, 0.0),  # projection of [0.0, 0.0, 0.0]
        Point(1.0, 0.0),  # projection of [1.0, 0.0, 0.0]
        Point(0.0, 1.0),  # projection of [0.0, 1.0, 0.0]
        Point(0.5, 0.5),   # projection of [0.0, 0.0, 1.0] (projected to 2D)
    ])

    println("Input points:")
    for p in points
        println("($(p.x), $(p.y))")
    end

    hull = convex_hull(points)

    println("\nConvex hull points:")
    for p in hull
        println("($(p.x), $(p.y))")
    end
end

# Run the test program
testks()
