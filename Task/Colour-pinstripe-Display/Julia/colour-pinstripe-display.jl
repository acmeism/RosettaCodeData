using Gtk, Graphics, Colors

function drawline(ctx, p1, p2, color, width)
    move_to(ctx, p1.x, p1.y)
    set_source(ctx, color)
    line_to(ctx, p2.x, p2.y)
    set_line_width(ctx, width)
    stroke(ctx)
end

const can = @GtkCanvas()
const win = GtkWindow(can, "Colour pinstripe/Display", 400, 400)
const colors = [colorant"black", colorant"red", colorant"green", colorant"blue",
          colorant"magenta", colorant"cyan", colorant"yellow", colorant"white"]
const numcolors = length(colors)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    deltaw = 1.0
    for (i, x) in enumerate(0:deltaw:w)
        drawline(ctx, Point(x, 0.25*h), Point(x, 0), colors[i % numcolors + 1], deltaw)
    end
    for (i, x) in enumerate(0:deltaw*2:w)
        drawline(ctx, Point(x, 0.5*h), Point(x, 0.25*h), colors[i % numcolors + 1], deltaw*2)
    end
    for (i, x) in enumerate(0:deltaw*3:w)
        drawline(ctx, Point(x, 0.75*h), Point(x, 0.5*h), colors[i % numcolors + 1], deltaw*3)
    end
    for (i, x) in enumerate(0:deltaw*4:w)
        drawline(ctx, Point(x, h), Point(x, 0.75*h), colors[i % numcolors + 1], deltaw*4)
    end
end


show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
