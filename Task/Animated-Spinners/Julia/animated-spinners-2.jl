""" https://rosettacode.org/wiki/Animated_Spinners """

using Gtk, Colors, Graphics, Cairo

""" Parameters for drawing the Gtk spinners app. """
struct Draw5Parameters
    dim::Vector{Int}
    xs::Vector{Float64}
    ys::Vector{Float64}
    deltas::Vector{Float64}
    previous::Vector{Float64}
    fps::Int
    colors::Vector{Colorant}
    Draw5Parameters() = new([800, 800], zeros(5), zeros(5), zeros(2), zeros(2), 150,
        [colorant"lightgreen", colorant"orange", colorant"red", colorant"white", colorant"yellow"])
end
const DP = Draw5Parameters()
const WIN = GtkWindow("Spinners", DP.dim[1], DP.dim[2])
const CANVAS = GtkCanvas()
push!(WIN, CANVAS)

@guarded Gtk.draw(CANVAS) do _
    """ Draw the spinners as a single line position. """
    ctx = getgc(CANVAS)
    h = height(ctx)
    w = width(ctx)
    if all(iszero, DP.xs) || w != DP.dim[1] || h != DP.dim[2]
        DP.dim .= w, h
        DP.xs .= [0.0, 50.0, -50.0, 50.0, -50.0] .* (w / 200) .+ (w / 2)
        DP.ys .= [0, 50, -50, -50, 50] .* (h / 200) .+ (h / 2)
        set_coordinates(ctx, BoundingBox(0, w, 0, h))
        set_source(ctx, colorant"gray")
        rectangle(ctx, 0, 0, w, h)
        fill(ctx)
        set_source(ctx, colorant"black")
        arc(ctx, h / 2, w / 2, w / 2, 0, 2π)
        fill(ctx)
    end
    r = w / 10
    for i in eachindex(DP.xs)
        set_line_width(ctx, 4.0)
        set_source(ctx, colorant"black")
        move_to(ctx, DP.xs[i], DP.ys[i])
        line_to(ctx, DP.xs[i] + r * DP.previous[1] * 1.1, DP.ys[i] + r * DP.previous[2] * 1.1)
        stroke(ctx)
        set_line_width(ctx, 2.0)
        set_source(ctx, DP.colors[i])
        move_to(ctx, DP.xs[i], DP.ys[i])
        line_to(ctx, DP.xs[i] + r * DP.deltas[1], DP.ys[i] + r * DP.deltas[2])
        stroke(ctx)
    end
    DP.previous .= DP.deltas
end

""" Run the spinners by drawing serial rotations in the angle of the lines. """
function spin()
    angle = 0.0
    while true
        angle = mod1(angle + 100 * rand(), 360)
        DP.deltas .= cospi(angle / 180), sinpi(angle / 180)
        draw(CANVAS)
        show(CANVAS)
        sleep(1 / DP.fps)
    end
end

@async spin()
