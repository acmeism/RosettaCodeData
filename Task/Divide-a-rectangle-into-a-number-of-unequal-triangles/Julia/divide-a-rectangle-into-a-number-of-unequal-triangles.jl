using Luxor
using Primes
using Random

mutable struct Triangle
    v1::Point
    v2::Point
    v3::Point
end

function cutrectangle(A, B, C, D, n)
    n < 2 && error("Cannot cut rectangle into < 2 triangles")
    triangles, i, j = [Triangle(A, B, C), Triangle(C, D, A)], 1, 2
    for _ in 2:n-1
        t = popfirst!(triangles)
        p = Point(t.v3.x + i/(2j) * (t.v1.x - t.v3.x), t.v3.y + i/(2j) * (t.v1.y - t.v3.y))
        push!(triangles, Triangle(t.v1, t.v2, p), Triangle(t.v2, t.v3, p))
        i, j = j, nextprime(j + 1)
    end
    return triangles
end

colors = shuffle(collect(Colors.color_names))
idx = 1
Drawing(500, 500)
origin()

triangles = cutrectangle(Point(0.0, 0.0), Point(200.0, 0.0), Point(200.0, 200.0), Point(0.0, 200.0), 9)

for t in triangles
    @show t
    sethue(colors[mod1(idx, length(colors))][1])
    poly([t.v1, t.v2, t.v3], :fill)
    global idx += 1
end

finish()
preview()
