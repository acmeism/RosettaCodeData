using Contour
import GLMakie as GM # GLMakie also defines Contour so import, not using

const example = Float64.([
    0 0 0 0 0;
    0 0 0 0 0;
    0 0 1 1 0;
    0 0 1 1 0;
    0 0 0 1 0;
    0 0 0 0 0;
])

const cl = first(levels(contours(1:6, 1:5, example)))
const xs, ys = coordinates(first(lines(cl)))

# Showing the points of the contour as origin (0, 0) at bottom left
const points = [(Int(round(ys[i])) - 1, 6 - Int(round(xs[i]))) for i in eachindex(xs)]
@show points

# oval of Cassini formula in z below, see formula at en.wikipedia.org/wiki/Cassini_oval#Equations
const xarray, yarray, a = -2.0:0.02:2.0, -2.0:0.02:2.0, 1.0
const z = [isapprox((x^2 + y^2)^2 - 2 * a^2 * (x^2 - y^2) + a^2, 1.0, atol=0.2) ? 1.0 : 0.0
    for x in xarray, y in yarray]

# The first (and pehaps only significant) level is the 0 <-> 1 transition border
# There are 3 separate contours at that level, on outside and 2 holes
const figeight = levels(contours(1:size(z, 1), 1:size(z, 2), z))
const ovalxs, ovalys = coordinates(lines(figeight[1])[1])
const ovalxs2, ovalys2 = coordinates(lines(figeight[1])[2])
const ovalxs3, ovalys3 = coordinates(lines(figeight[1])[3])

const oplot = GM.plot(z)
GM.lines!(ovalxs, ovalys, color = :red, linewidth = 4)
GM.lines!(ovalxs2, ovalys2, color = :white, linewidth = 4)
GM.lines!(ovalxs3, ovalys3, color = :lightgreen, linewidth = 4)
GM.display(oplot)
