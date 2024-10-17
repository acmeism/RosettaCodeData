using Gtk, Colors, Graphics, Dates

const radius = 300
const win = GtkWindow("Clock", radius, radius)
const can = GtkCanvas()
push!(win, can)

global drawcontext = []

function drawline(ctx, l, color)
    isempty(l) && return
    p = first(l)
    move_to(ctx, p.x, p.y)
    set_source(ctx, color)
    for i = 2:length(l)
        p = l[i]
        line_to(ctx, p.x, p.y)
    end
    stroke(ctx)
end

function clockbody(ctx)
    set_coordinates(ctx, BoundingBox(0, 100, 0, 100))
    rectangle(ctx, 0, 0, 100, 100)
    set_source(ctx, colorant"yellow")
    fill(ctx)
    set_source(ctx, colorant"blue")
    arc(ctx, 50, 50, 45, 45, 360)
    stroke(ctx)
    for hr in 1:12
        radians = hr * pi / 6.0
        drawline(ctx, [Point(50 + 0.95 * 45 * sin(radians),
            50 - 0.95 * 45 * cos(radians)),
            Point(50 + 1.0 * 45 * sin(radians),
            50 - 1.0 * 45 * cos(radians))], colorant"blue")
    end
end

Gtk.draw(can) do widget
    ctx = getgc(can)
    if length(drawcontext) < 1
        push!(drawcontext, ctx)
    else
        drawcontext[1] = ctx
    end
    clockbody(ctx)
end

function update(can)
    dtim = now()
    hr = hour(dtim)
    mi = minute(dtim)
    sec = second(dtim)
    if length(drawcontext) < 1
        return
    end
    ctx = drawcontext[1]
    clockbody(ctx)
    rad = (hr % 12) * pi / 6.0 + mi * pi / 360.0
    drawline(ctx, [Point(50, 50),
        Point(50 + 45 * 0.5 * sin(rad), 50 - 45 * 0.5 * cos(rad))], colorant"black")
    stroke(ctx)
    rad = mi * pi / 30.0  + sec * pi / 1800.0
    drawline(ctx, [Point(50, 50),
        Point(50 + 0.7 * 45 * sin(rad), 50 - 0.7 * 45 * cos(rad))], colorant"darkgreen")
    stroke(ctx)
    rad = sec * pi / 30.0
    drawline(ctx, [Point(50, 50),
        Point(50 + 0.9 * 45 * sin(rad), 50 - 0.9 * 45 * cos(rad))], colorant"red")
    stroke(ctx)
    reveal(can)
end

Gtk.showall(win)
sloc = Base.Threads.SpinLock()
lock(sloc)
signal_connect(win, :destroy) do widget
    unlock(sloc)
end
while !trylock(sloc)
    update(win)
    sleep(1.0)
end
