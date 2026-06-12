using Graphics, Plots

Point(t::Tuple) = Vec2(Float64(t[1]), Float64(t[2]))
const controlpoints = Point.([(171, 171), (185, 111), (202, 109), (202, 189), (328, 160),
    (208, 254), (241, 330), (164,252), (69, 278), (139, 208), (72, 148), (168, 172)])
plt = plot(map(a -> a.x, controlpoints), map(a -> a.y, controlpoints))
savefig(plt, "BSplineplot.png")
