using Plots

struct Point; x::Float64; y::Float64; end
# Find a circle passing through the 3 points
const p1 = Point(10, 10)
const p2 = Point(100, 200)
const p3 = Point(200, 10)
const allp = [p1, p2, p3]

# set up problem matrix and solve.
# if (x - a)^2 + (y - b)^2 = r^2 then for some D, E, F, x^2 + y^2 + Dx + Ey + F = 0
# therefore Dx + Ey + F = -x^2 - y^2
v = zeros(Int, 3)
m = zeros(Int, 3, 3)
for row in 1:3
    m[row, 1:3] .= [allp[row].x, allp[row].y, 1]
    v[row] = -(allp[row].x)^2 - (allp[row].y)^2
end
q = (m \ v)  # [-210.0, -162.632, 3526.32]
a, b, r = -q[1] / 2, -q[2] / 2, sqrt((q[1]^2/4) + q[2]^2/4 - q[3])

println("The circle with center at x = $a, y = $b and radius $r.")

x = a-r:0.25:a+r
y0 = sqrt.(r^2 .- (x .- a).^2)
plt = plot(x, y0 .+ b, color = :red)
plot!(x, b .- y0, color = :red)
scatter!([p.x for p in allp], [p.y for p in allp],  markersize = r / 10)
