using Gtk, Graphics, Colors

const win = GtkWindow("Color Wheel", 450, 450) |> (const can = @GtkCanvas())
set_gtk_property!(can, :expand, true)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    center = (x = w / 2, y = h / 2)
    anglestep = 1/w
    for θ in 0:0.1:360
        rgb = RGB(HSV(θ, 1, 1))
        set_source_rgb(ctx, rgb.r, rgb.g, rgb.b)
        line_to(ctx, center...)
        arc(ctx, center.x, center.y, w/2.2, 2π * θ / 360, anglestep)
        line_to(ctx, center...)
        stroke(ctx)
    end
end

show(can)
const condition = Condition()
endit(w) = notify(condition)
signal_connect(endit, win, :destroy)
wait(condition)
