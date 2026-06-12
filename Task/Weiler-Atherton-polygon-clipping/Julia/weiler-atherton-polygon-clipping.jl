struct Point
    x::Int
    y::Int
end

Base.:(==)(a::Point, b::Point) = a.x == b.x && a.y == b.y
Base.:(!=)(a::Point, b::Point) = !(a == b)

struct Line
    start::Point
    end_::Point  # Using end_ since 'end' is a reserved keyword in Julia
end

struct Polygon
    points::Vector{Point}
end

@enum InterVertexType begin
    InsideVertex
    OutsideVertex
    InIntersection
    OutIntersection
end

struct InterVertex
    type::InterVertexType
    point::Point
end

function get_point(vertex::InterVertex)
    return vertex.point
end

function get_first_in_intersection(list::Vector{InterVertex})
    found = 0
    result = nothing

    for i in 1:length(list)
        if list[i].type == InIntersection
            found = i
            result = get_point(list[i])
            break
        end
    end

    if found > 0
        deleteat!(list, 1:found-1)
    end

    return result
end

@enum PolyListOptionType begin
    List
    InsidePoly
    None
end

struct PolyListOption
    type::PolyListOptionType
    interVertexList::Vector{InterVertex}
    points::Vector{Point}
end

function is_in_polygon(point::Point, poly::Polygon)
    x = point.x
    y = point.y
    inside = false
    j = length(poly.points)

    for i in 1:length(poly.points)
        xi = poly.points[i].x
        yi = poly.points[i].y
        xj = poly.points[j].x
        yj = poly.points[j].y

        intersect = ((yi > y) != (yj > y)) &&
                    (x < (xj - xi) * (y - yi) / (yj - yi) + xi)

        if intersect
            inside = !inside
        end

        j = i
    end

    return inside
end

function distance_cmp(self::Point, first::Point, second::Point)
    dst_first = abs(self.x - first.x) + abs(self.y - first.y)
    dst_second = abs(self.x - second.x) + abs(self.y - second.y)

    if dst_first < dst_second
        return -1
    elseif dst_first > dst_second
        return 1
    else
        return 0
    end
end

function is_in_line(point::Point, line::Line)
    dxc = point.x - line.start.x
    dyc = point.y - line.start.y

    dxl = line.end_.x - line.start.x
    dyl = line.end_.y - line.start.y

    cross = dxc * dyl - dyc * dxl

    if cross != 0
        return false
    end

    if abs(dxl) >= abs(dyl)
        if dxl > 0
            return line.start.x <= point.x && point.x <= line.end_.x
        else
            return line.end_.x <= point.x && point.x <= line.start.x
        end
    else
        if dyl > 0
            return line.start.y <= point.y && point.y <= line.end_.y
        else
            return line.end_.y <= point.y && point.y <= line.start.y
        end
    end
end

function get_intersection(self::Line, line::Line)
    line_1_start = self.start
    line_1_end = self.end_
    line_2_start = line.start
    line_2_end = line.end_

    den = ((line_2_end.y - line_2_start.y) * (line_1_end.x - line_1_start.x)) -
          ((line_2_end.x - line_2_start.x) * (line_1_end.y - line_1_start.y))

    if den == 0
        return nothing
    end

    a = line_1_start.y - line_2_start.y
    b = line_1_start.x - line_2_start.x

    num_1 = ((line_2_end.x - line_2_start.x) * a) - ((line_2_end.y - line_2_start.y) * b)
    num_2 = ((line_1_end.x - line_1_start.x) * a) - ((line_1_end.y - line_1_start.y) * b)

    a_f = num_1 / den
    b_f = num_2 / den

    if a_f < 0.0 || a_f > 1.0 || b_f < 0.0 || b_f > 1.0
        return nothing
    end

    result = Point(
        line_1_start.x + round(Int, a_f * (line_1_end.x - line_1_start.x)),
        line_1_start.y + round(Int, a_f * (line_1_end.y - line_1_start.y))
    )

    return result
end

function is_clockwise(poly::Polygon)
    sum = 0
    for i in 1:length(poly.points)
        j = (i != length(poly.points)) ? i + 1 : 1
        sum += (poly.points[j].x - poly.points[i].x) * (poly.points[j].y + poly.points[i].y)
    end
    return sum < 0
end

function get_reversed(poly::Polygon)
    reversed_points = reverse(poly.points)
    return Polygon(reversed_points)
end

function get_first_outside_vertex_index(subject::Polygon, poly::Polygon)
    for i in 1:length(subject.points)
        if !is_in_polygon(subject.points[i], poly)
            return i
        end
    end
    return nothing
end

function get_first_inside_vertex_index(subject::Polygon, poly::Polygon)
    for i in 1:length(subject.points)
        if is_in_polygon(subject.points[i], poly)
            return i
        end
    end
    return nothing
end

function get_intersections_with_line(poly::Polygon, line::Line, cursor_inside::Ref{Bool})
    intersections = Point[]

    for i in 1:length(poly.points)
        start = poly.points[i]
        next_i = (i == length(poly.points)) ? 1 : i + 1
        end_ = poly.points[next_i]

        l = Line(start, end_)
        intersection = get_intersection(l, line)

        if intersection !== nothing && intersection != line.start && intersection != line.end_ &&
           intersection != start && intersection != end_
            push!(intersections, intersection)
        end
    end

    sort!(intersections, lt = (a, b) -> distance_cmp(line.start, a, b) < 0)

    result = InterVertex[]
    for x in intersections
        if cursor_inside[]
            cursor_inside[] = !cursor_inside[]
            push!(result, InterVertex(OutIntersection, x))
        else
            cursor_inside[] = !cursor_inside[]
            push!(result, InterVertex(InIntersection, x))
        end
    end

    return result
end

function get_inter_vertex_list(subject::Polygon, poly::Polygon)
    subject_copy = subject
    if !is_clockwise(subject_copy)
        subject_copy = get_reversed(subject_copy)
    end

    cursor_inside = Ref{Bool}(false)
    intersection_count = 0

    start_index_opt = get_first_outside_vertex_index(subject_copy, poly)
    if start_index_opt !== nothing
        start_index = start_index_opt

        if get_first_inside_vertex_index(subject_copy, poly) === nothing
            all_inside = true
            for point in poly.points
                if !is_in_polygon(point, subject_copy)
                    all_inside = false
                    break
                end
            end

            if all_inside
                return PolyListOption(InsidePoly, InterVertex[], poly.points)
            end
        end

        result = InterVertex[]

        for i_offset in 0:(length(subject_copy.points)-1)
            i = mod1(start_index + i_offset, length(subject_copy.points))
            start = subject_copy.points[i]

            # Check vertex
            if i != start_index && is_in_polygon(start, poly)
                push!(result, InterVertex(InsideVertex, start))
            else
                push!(result, InterVertex(OutsideVertex, start))
            end

            # Check intersection
            next_i = (i == length(subject_copy.points)) ? 1 : i + 1
            end_ = subject_copy.points[next_i]
            line = Line(start, end_)

            intersections = get_intersections_with_line(poly, line, cursor_inside)
            intersection_count += length(intersections)

            append!(result, intersections)
        end

        # Check if there are any intersections
        has_intersections = false
        for vertex in result
            if vertex.type == InIntersection || vertex.type == OutIntersection
                has_intersections = true
                break
            end
        end

        if !has_intersections
            return PolyListOption(None, InterVertex[], Point[])
        else
            return PolyListOption(List, result, Point[])
        end
    else
        return PolyListOption(InsidePoly, InterVertex[], subject.points)
    end
end

function collect_from_list(list::Vector{InterVertex}, start_point::Point)
    initial_vertex_not_found = true
    last_point = nothing
    start_i = 1  # Changed from 0 to 1 for Julia's 1-based indexing
    end_i = 1    # Changed from 0 to 1

    # Check if list is empty
    if isempty(list)
        return nothing
    end

    dont_skip = get_point(list[1]) == start_point

    points = Point[]
    i = 1

    # Skip until InIntersection occurs, but include the InIntersection
    while i <= length(list) && initial_vertex_not_found && !dont_skip
        next = (i == length(list)) ? 1 : i + 1
        if next <= length(list)  # Added safety check
            next_point = list[next]

            if next_point.type == InIntersection || next_point.type == OutIntersection
                if get_point(next_point) == start_point
                    start_i = next
                    initial_vertex_not_found = false
                    break
                end
            end
        end
        i += 1
    end

    # Collect points
    if !initial_vertex_not_found || dont_skip
        i = start_i
        continue_collecting = true

        while continue_collecting && i <= length(list)
            vertex = list[i]

            if vertex.type == OutIntersection
                end_i = i
                last_point = get_point(vertex)
                continue_collecting = false
            else
                push!(points, get_point(vertex))
            end

            i += 1
        end
    end

    # Fix deletion logic for Julia's 1-based indexing
    if end_i >= start_i && start_i <= length(list)
        amount = end_i - start_i + 1
        if start_i + amount - 1 <= length(list)
            deleteat!(list, start_i:(start_i+amount-1))
        else
            deleteat!(list, start_i:length(list))
        end
    end

    if !isempty(points) && last_point !== nothing
        return (points, last_point)
    else
        return nothing
    end
end

function get_clip_polygon(
    subject::Vector{InterVertex},
    clip::Vector{InterVertex},
    initial::Point)

    result = Point[]
    subject_as_list = true
    start_point = initial

    # Ensure subject is not empty before accessing its last element
    if isempty(subject)
        return nothing
    end

    end_point = get_point(subject[end])

    while !(initial == end_point)
        values = collect_from_list(
            subject_as_list ? subject : clip,
            start_point)

        if values !== nothing
            edges, end_ = values
            end_point = end_
            start_point = end_
            subject_as_list = !subject_as_list

            append!(result, edges)
        else
            println("something went wrong")
            println("res size: ", length(result))
            return nothing
        end
    end

    if !isempty(result)
        # Filter consecutive duplicate points
        unique_result = Point[]
        for p in result
            if isempty(unique_result) || unique_result[end] != p
                push!(unique_result, p)
            end
        end

        return unique_result
    else
        return nothing
    end
end

function get_clip_polygons(
    subject::Vector{InterVertex},
    clip::Vector{InterVertex})

    result = Vector{Point}[]

    while true
        start_point_opt = get_first_in_intersection(subject)
        if start_point_opt === nothing
            break
        end

        poly = get_clip_polygon(subject, clip, start_point_opt)
        if poly !== nothing
            push!(result, poly)
        else
            break
        end
    end

    if !isempty(result)
        return result
    else
        return nothing
    end
end

function clip(self::Polygon, other::Polygon)
    option = get_inter_vertex_list(self, other)
    other_option = get_inter_vertex_list(other, self)

    if option.type == List
        subject_list = option.interVertexList

        if other_option.type == List
            clip_list = other_option.interVertexList
            return get_clip_polygons(subject_list, clip_list)
        elseif other_option.type == InsidePoly
            result = Vector{Point}[]
            push!(result, other_option.points)
            return result
        else # None
            return nothing
        end
    elseif option.type == InsidePoly
        result = Vector{Point}[]
        push!(result, option.points)
        return result
    else # None
        return nothing
    end
end

# Testing function
function run_tests()
    # Test is_in_line
    begin
        p = Point(5, 10)
        line = Line(Point(5, 5), Point(5, 20))
        result = is_in_line(p, line)
        println("is_in_line test 1: ", result ? "PASS" : "FAIL")

        p_f = Point(3, 4)
        line_f = Line(Point(5, 5), Point(5, 20))
        result_f = is_in_line(p_f, line_f)
        println("is_in_line test 2: ", !result_f ? "PASS" : "FAIL")
    end

    # Test clip
    begin
        poly = Polygon([
            Point(180, 420), Point(180, 120), Point(520, 120),
            Point(520, 420), Point(420, 420), Point(320, 220)
        ])

        inter_polygon = Polygon([
            Point(60, 220), Point(330, 120), Point(410, 290),
            Point(80, 480), Point(280, 280)
        ])

        polygons = clip(poly, inter_polygon)
        if polygons !== nothing && !isempty(polygons)
            println("clip test: PASS - Found ", length(polygons), " polygons")

            # Print first polygon points
            if !isempty(polygons[1])
                println("First polygon points:")
                for p in polygons[1]
                    println("  Point: (", p.x, ", ", p.y, ")")
                end
            end
        else
            println("clip test: FAIL - No polygons found")
        end
    end
end

# Main function
function main()
    run_tests()
end

main()
