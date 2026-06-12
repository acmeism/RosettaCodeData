using Luxor, Thebes, Rotations, Colors, LinearAlgebra

""" 3D turtle struct """
mutable struct Turtle3D
	position::Point3D           # Current position in 3D space
	orientation::QuatRotation   # Orientation as a quaternion
	pendown::Bool               # Pen state
	pencolor::RGB               # Pen color
	penwidth::Float64           # Pen width
	path::Vector{Point3D}       # Store 3D points for drawing continuous lines
end

""" Create a new Turtle3D instance with initial position and others as defaults """
function Turtle3D(
	pos = Point3D(0, 0, 0),
	ori = QuatRotation(1.0, 0, 0, 0),
	pen = true,
	color = RGB(1, 0, 0),
	width = 1.0,
)
	Turtle3D(pos, ori, pen, color, width, Vector{Point3D}([pos]))
end

""" Move turtle to a specific Point3D position """
function MoveTo(t::Turtle3D, new_pos::Point3D)
	if t.pendown
		push!(t.path, new_pos)
	end
	t.position = new_pos
end

""" Move turtle 'distance' forward in the orientation it is currently facing """
function Forward(t::Turtle3D, distance::Real)
	forward_dir = t.orientation * [0, 0, 1]
	new_pos = t.position + distance * Point3D(forward_dir...)
	if t.pendown
		push!(t.path, new_pos)
	end
	t.position = new_pos
end

""" Pen control, start drawing line along path """
function Pendown(t::Turtle3D)
	if !t.pendown
		push!(t.path, t.position)
	end
	t.pendown = true
end

""" Pen control, stop drawing line along path, keep the current position """
Penup(t::Turtle3D) = (t.pendown = false)

""" Rotate around local y-axis (yaw) """
function Turn(t::Turtle3D, angle_deg::Real)
	angle_rad = deg2rad(angle_deg)
	rot = QuatRotation(RotY(angle_rad))
	t.orientation = t.orientation * rot
end

""" Pitch: Rotate around local x-axis """
function Pitch(t::Turtle3D, angle_deg::Real)
	angle_rad = deg2rad(angle_deg)
	rot = QuatRotation(RotX(angle_rad))
	t.orientation = t.orientation * rot
end

""" Roll: Rotate around local z-axis """
function Roll(t::Turtle3D, angle_deg::Real)
	angle_rad = deg2rad(angle_deg)
	rot = QuatRotation(RotZ(angle_rad))
	t.orientation = t.orientation * rot
end

""" Set the pen color using r, g, b as RGB values """
Pencolor(t::Turtle3D, r::Real, g::Real, b::Real) = (t.pencolor = RGB(r, g, b))

""" Set the pen stroke width """
Penwidth(t::Turtle3D, w::Real) = (t.penwidth = w)

"""
Transform a local 3D point by the Turtle3D's current position and orientation.
"""
function transformpoint(t::Turtle3D, point::Point3D)
	rotated = t.orientation * [point.x, point.y, point.z]
	return t.position + Point3D(rotated...)
end

"""
Generate 3D edges of a rectangular prism (cuboid).
The cuboid's bottom-left-front corner is at the turtle's current position.
"""
function cuboidedges(t::Turtle3D, width::Real, depth::Real, height::Real; upward::Bool = false)
	if upward
		base = t.position
		v1 = base
		v2 = base + Point3D(width, 0, 0)
		v3 = base + Point3D(width, depth, 0)
		v4 = base + Point3D(0, depth, 0)
		v5 = base + Point3D(0, 0, height)
		v6 = base + Point3D(width, 0, height)
		v7 = base + Point3D(width, depth, height)
		v8 = base + Point3D(0, depth, height)
		vertices = [v1, v2, v3, v4, v5, v6, v7, v8]
	else
		# Original behavior: height along turtle's local Z-axis
		v1 = Point3D(0, 0, 0)
		v2 = Point3D(width, 0, 0)
		v3 = Point3D(width, depth, 0)
		v4 = Point3D(0, depth, 0)
		v5 = Point3D(0, 0, height)
		v6 = Point3D(width, 0, height)
		v7 = Point3D(width, depth, height)
		v8 = Point3D(0, depth, height)
		verts = [v1, v2, v3, v4, v5, v6, v7, v8]
		vertices = [transformpoint(t, lv) for lv in verts]
	end

	# Define edges as pairs of world-transformed vertices
	edges = [
		# Bottom face edges
		(vertices[1], vertices[2]),
		(vertices[2], vertices[3]),
		(vertices[3], vertices[4]),
		(vertices[4], vertices[1]),
		# Top face edges
		(vertices[5], vertices[6]),
		(vertices[6], vertices[7]),
		(vertices[7], vertices[8]),
		(vertices[8], vertices[5]),
		# Vertical edges connecting bottom to top faces
		(vertices[1], vertices[5]),
		(vertices[2], vertices[6]),
		(vertices[3], vertices[7]),
		(vertices[4], vertices[8]),
	]
	return edges
end

"""
Generate the 3D edges of a pyramid with a rectangular base.
"""
function pyramidedges(t::Turtle3D, base_width::Real, base_depth::Real, height::Real)
	halfwidth = base_width / 2
	halfdepth = base_depth / 2
	b1 = Point3D(-halfwidth, -halfdepth, 0)
	b2 = Point3D(halfwidth, -halfdepth, 0)
	b3 = Point3D(halfwidth, halfdepth, 0)
	b4 = Point3D(-halfwidth, halfdepth, 0)
	apex = Point3D(0, 0, height)
	vertices = [transformpoint(t, lv) for lv in [b1, b2, b3, b4, apex]]
	edges = [
		(vertices[1], vertices[2]),
		(vertices[2], vertices[3]),
		(vertices[3], vertices[4]),
		(vertices[4], vertices[1]),
		(vertices[1], vertices[5]),
		(vertices[2], vertices[5]),
		(vertices[3], vertices[5]),
		(vertices[4], vertices[5]),
	]
	return edges
end

"""
Draw a list of 3D edges by projecting them to 2D and drawing the projected lines.
"""
function drawedges(
	edges::Vector{Tuple{Point3D, Point3D}};
	offset = Point3D(0, 0, 0),
	penwidth = 1.0,
	pencolor = RGB(1, 0, 0),
)
	setline(penwidth)
	sethue(pencolor)
	setlinecap("round")
	for (p1, p2) in edges
		p1_2d = project(p1 + offset)
		p2_2d = project(p2 + offset)
		if !isnothing(p1_2d) && !isnothing(p2_2d)
			line(p1_2d, p2_2d, :stroke)
		end
	end
end

"""
Draw a Turtle3D's path as a sequence of 3D lines using Thebes projection.
"""
function turtle(t::Turtle3D; offset = Point3D(0, 0, 0))
	setline(t.penwidth)
	sethue(t.pencolor)
	setlinecap("round")
	path2d = Luxor.Point[]
	for p in t.path
		p2d = project(p + offset)
		!isnothing(p2d) && push!(path2d, p2d)
	end
	for i in (firstindex(path2d)+1):lastindex(path2d)
		if !isnothing(path2d[i]) && !isnothing(path2d[i-1])
			line(path2d[i-1], path2d[i], :stroke)
		end
	end
	p2d = project(t.position + offset)
	if !isnothing(p2d)
		sethue("white")
		Luxor.circle(p2d, 5, :fill)
	end
end

"""
Generate 3D edges for a house consisting of a cuboid base and a pyramid roof.
"""
function house(t::Turtle3D, size::Real = 50.0)
	all_edges = Tuple{Point3D, Point3D}[]
	edges = cuboidedges(t, size, size, size)
	append!(all_edges, edges)
	pyramid = Point3D(size/2, size/2, size)
	pyramid = transformpoint(t, pyramid)
	turtle = Turtle3D(pyramid, t.orientation, false, t.pencolor, t.penwidth)
	edges = pyramidedges(turtle, size, size, size)
	append!(all_edges, edges)
	return all_edges
end

"""
Generate simulated a 3D bar chart.
"""
function fivebarchart(t::Turtle3D, heights::Vector{T} = [80, 120, 60, 150, 75]) where T <: Real
	all_edges = Vector{Tuple{Point3D, Point3D}}()
	pos = t.position
	for i in eachindex(heights)
		cuboidpos = pos + Point3D(200 * (i-1), 0, 0)
		turtle = Turtle3D(cuboidpos, QuatRotation(1.0, 0, 0, 0), false, t.pencolor, t.penwidth)
		cuboid_edges = cuboidedges(turtle, 50.0, 50.0, heights[i], upward = true)
		append!(all_edges, cuboid_edges)
	end
	return all_edges
end

""" Draw 3D spiral by moving the turtle along a spiral path. """
function spiral3D(🐢 = Turtle3D())
	Pendown(🐢)
	Pencolor(🐢, 0.0, 1.0, 0.0)
	Penwidth(🐢, 3.0)
	for i in 1:200
		Forward(🐢, 2 + 0.1 * i)
		Turn(🐢, 20)
		Pitch(🐢, 5)
		Roll(🐢, 3)
	end
end

""" Main function to run examples including spiral, house, and bar chart """
function main()
	🐢_spiral = Turtle3D(Point3D(-300, 0, 0))
	🐢_house = Turtle3D(Point3D(200, 200, 0))
	🐢_bar = Turtle3D(Point3D(-300, -300, 0))
	spiral3D(🐢_spiral)
	house_edges = house(🐢_house, 100)
	bar_chart_edges = fivebarchart(🐢_bar)
	@draw begin
		background("black")
		eyepoint(Point3D(1500, 1500, 1500))
		turtle(🐢_spiral, offset = Point3D(0, 0, 0))
		drawedges(house_edges, offset = Point3D(0, 0, 0), penwidth = 8.0, pencolor = RGB(0, 0, 1))
		drawedges(bar_chart_edges, offset = Point3D(0, 0, 0), penwidth = 8.0, pencolor = RGB(1, 0, 0))
	end 2000 2000
end

main()
