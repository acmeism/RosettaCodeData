using Gtk.ShortNames, GtkReactive, Graphics, Cairo, Colors, Random

mutable struct Hexagon
    center::Point
    radius::Int
    letter::String
    color::Colorant
end

const offset = 50
const hgt = 450
const wid = 400
const hcombdim = (rows = 5, cols = 4)
const randletters = reshape(string.(Char.(shuffle(UInt8('A'):UInt8('Z'))))[1:20], Tuple(hcombdim))
const win = Window("Honeycombs", wid, hgt)
const can = Canvas()
const honeycomb = Dict{Point, Hexagon}()
const chosen = Vector{String}()

function hexmat(p, rad)
    shor = rad * 0.5
    long = rad * sqrt(3.0) / 2.0
    mat = reshape([shor, long, -shor, long, Float64(-rad), 0.0, -shor, -long, shor, -long, Float64(rad), 0.0], 2, 6)
    [Point(mat[1, n] + p.x, mat[2, n] + p.y) for n in 1:6]
end

function whichclicked(clickpos)
    centers = [c for c in keys(honeycomb)]
    (maybeclicked, idx) = findmin(map(c -> sqrt((clickpos.x - c.x)^2 + (clickpos.y - c.y)^2), centers))
    return maybeclicked < offset * sqrt(3) / 2.0 ? centers[idx] : nothing
end

whichtyped(ch) = (for (k, v) in honeycomb if v.letter == ch return k end end; nothing)

function hexagon(ctx, pos, rad, ltr, colr = colorant"yellow")
    set_source(ctx, colr)
    points = hexmat(pos, rad)
    set_line_width(ctx, 4)
    polygon(ctx, points)
    close_path(ctx)
    fill(ctx)
    set_source(ctx, colorant"black")
    polygon(ctx, points)
    close_path(ctx)
    stroke(ctx)
    move_to(ctx, pos.x - (ltr == "I" ? 7 : 18), pos.y + 15)
    set_source(ctx, colr == colorant"yellow" ? colorant"red" : colorant"black")
    set_font_size(ctx, offset)
    show_text(ctx, ltr)
    Hexagon(pos, rad, ltr, colr)
end

hexagon(ctx, h::Hexagon) = hexagon(ctx, h.center, h.radius, h.letter, h.color)

function makehoneycomb(ctx)
    centers = fill(Point(0, 0), hcombdim.rows, hcombdim.cols)
    xdelta = 75.0
    ydelta = 90.0
    for i in 1:hcombdim.rows, j in 1:hcombdim.cols
        center = Point((i - 1) * xdelta + offset, (j - 1) * ydelta + ((i - 1 ) % 2 + 1) * offset)
        centers[i, j] = center
        honeycomb[center] = hexagon(ctx, center, offset, randletters[i, j])
    end
    centers
end

@guarded draw(can) do widget
    ctx = getgc(can)
    if length(honeycomb) == 0
        makehoneycomb(ctx)
    else
        map(c -> hexagon(ctx, honeycomb[c]), collect(keys(honeycomb)))
    end
end

""" At entry to this function we have just found out what letter was chosen."""
function changecolor(colr)
    h = honeycomb[colr]
    h.color = colorant"violet"
    hexagon(getgc(can), h)
    reveal(win, true)
    push!(chosen, h.letter)
    if all(map(k -> honeycomb[k].color == colorant"violet", collect(keys(honeycomb))))
        println("All hexagons ($chosen, and the last letter was $(chosen[end])) have been chosen. Exiting.")
        exit(0)
    end
end

signal_connect(win, "key-press-event") do widget, event
    if (whichhexgon = whichtyped(string(uppercase(Char(event.keyval))))) != nothing
        changecolor(whichhexgon)
    end
end

can.mouse.button1press = @guarded (widget, event) -> begin
    if (whichhexgon = whichclicked(Point(event.x, event.y))) != nothing
        changecolor(whichhexgon)
    end
end

push!(win, can)
show(can)
condition = Condition()
endit(w) = notify(condition)
signal_connect(endit, win, :destroy)
show(win)
wait(condition)
exit()
