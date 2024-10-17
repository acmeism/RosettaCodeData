using Gtk, Cairo, ColorTypes

function generategrays(n, screenwidth)
    verts = Vector{RGB}()
    hwidth = Int(ceil(screenwidth/n))
    for x in 00:Int(floor(0xff/(n-1))):0xff
        rgbgray = RGB(x/255, x/255, x/255)
        for i in 1:hwidth
            push!(verts, rgbgray)
        end
    end
    verts
end

function drawline(ctx, p1, p2, color, width)
    move_to(ctx, p1.x, p1.y)
    set_source(ctx, color)
    line_to(ctx, p2.x, p2.y)
    set_line_width(ctx, width)
    stroke(ctx)
end

const can = @GtkCanvas()
const win = GtkWindow(can, "Grayscale bars/Display", 400, 400)
fullscreen(win)  # start full screen, then reduce to regular window in 5 seconds.

draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    gpoints = generategrays(8, w)
    for (i, x) in enumerate(0:w-1)
        drawline(ctx, Point(x, 0.25*h), Point(x, 0), gpoints[i], 1)
    end
    gpoints = reverse(generategrays(16, w))
    for (i, x) in enumerate(0:w-1)
        drawline(ctx, Point(x, 0.5*h), Point(x, 0.25*h), gpoints[i], 1)
    end
    gpoints = generategrays(32, w)
    for (i, x) in enumerate(0:w-1)
        drawline(ctx, Point(x, 0.75*h), Point(x, 0.5*h), gpoints[i], 1)
    end
    gpoints = reverse(generategrays(64, w))
    for (i, x) in enumerate(0:w-1)
        drawline(ctx, Point(x, h), Point(x, 0.75*h), gpoints[i], 1)
    end
end

show(can)
sleep(5)
unfullscreen(win)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
