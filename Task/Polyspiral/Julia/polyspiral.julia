using Gtk, Graphics, Colors

const can = @GtkCanvas()
const win = GtkWindow(can, "Polyspiral", 360, 360)

const drawiters = 72
const colorseq = [colorant"blue", colorant"red", colorant"green", colorant"black", colorant"gold"]
const angleiters = [0, 0, 0]
const angles = [75, 100, 135, 160]

Base.length(v::Vec2) = sqrt(v.x * v.x + v.y * v.y)

function drawline(ctx, p1, p2, color, width=1)
    move_to(ctx, p1.x, p1.y)
    set_source(ctx, color)
    line_to(ctx, p2.x, p2.y)
    set_line_width(ctx, width)
    stroke(ctx)
end

@guarded draw(can) do widget
    δ(r, θ) = Vec2(r * cospi(θ/180), r * sinpi(θ/180))
    nextpoint(p, r, θ) = (dp = δ(r, θ); Point(p.x + dp.x, p.y + dp.y))
    colorindex = (angleiters[1] % 5) + 1
    colr = colorseq[colorindex]
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    x = 0.5 * w
    y = 0.5 * h
    θ = angleiters[2] * rand() * 3
    δθ = angleiters[2]
    r = 5
    δr = 3
    p1 = Point(x, y)
    for i in 1:drawiters
        if angleiters[3] == 0
            set_source(ctx, colorant"gray90")
            rectangle(ctx, 0, 0, w, h)
            fill(ctx)
            continue
        end
        p2 = nextpoint(p1, r, θ)
        drawline(ctx, p1, p2, colr, 2)
        θ = θ + δθ
        r = r + δr
        p1 = p2
    end
end

show(can)

while true
    angleiters[2] = angles[angleiters[1] % 3 + 1]
    angleiters[1] += 1
    angleiters[3] = angleiters[3] == 0 ? 1 : 0
    draw(can)
    yield()
    sleep(0.5)
end
