using Luxor

isinside(p, a, b) = (b.x - a.x) * (p.y - a.y) > (b.y - a.y) * (p.x - a.x)

function intersection(a, b, s, f)
    dc = [a.x - b.x, a.y - b.y]
    dp = [s.x - f.x, s.y - f.y]
    n1 = a.x * b.y - a.y * b.x
    n2 = s.x * f.y - s.y * f.x
    n3 = 1.0 / (dc[1] * dp[2] - dc[2] * dp[1])
    Point((n1 * dp[1] - n2 * dc[1]) * n3, (n1 * dp[2] - n2 * dc[2]) * n3)
end

function clipSH(spoly, cpoly)
    outarr = spoly
    q = cpoly[end]
    for p in cpoly
        inarr = outarr
        outarr = Point[]
        s = inarr[end]
        for vtx in inarr
            if isinside(vtx, q, p)
                if !isinside(s, q, p)
                    push!(outarr, intersection(q, p, s, vtx))
                end
                push!(outarr, vtx)
            elseif isinside(s, q, p)
                push!(outarr, intersection(q, p, s, vtx))
            end
            s = vtx
        end
        q = p
    end
    outarr
end

subjectp = [Point(50, 150), Point(200, 50), Point(350, 150), Point(350, 300),
    Point(250, 300), Point(200, 250), Point(150, 350), Point(100, 250), Point(100, 200)]

clipp = [Point(100, 100), Point(300, 100), Point(300, 300), Point(100, 300)]

Drawing(400, 400, "intersecting-polygons.png")
background("white")
sethue("red")
poly(subjectp, :stroke, close=true)
sethue("blue")
poly(clipp, :stroke, close=true)
clipped = clipSH(subjectp, clipp)
sethue("gold")
poly(clipped, :fill, close=true)
finish()
preview()
println(clipped)
