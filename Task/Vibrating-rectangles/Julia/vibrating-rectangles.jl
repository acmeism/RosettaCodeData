using Gtk, Graphics, Colors

const height, width, x0, y0 = 480, 640, 320, 240
const can = @GtkCanvas()
const win = GtkWindow(can, "Vibrating Rectangles", width, height)
const colrs = colormap("rdBu")
const sizes = collect(2:4:div(width, 2))
const params = [1, 2]

draw(can) do widget
    ctx = getgc(can)
    set_line_width(ctx, 1)
    c = colrs[params[1]]
    set_source_rgb(ctx, c.r, c.g, c.b)
    i = sizes[params[2]]
    rectangle(ctx, x0 - i, y0 - i, 2i, div(8i, 3))
    stroke(ctx)
end

while true
    params[1] = params[1] % 99 + 1
    params[2] = params[2] % (length(sizes) - 1) + 1
    draw(can)
    show(can)
    sleep(0.25)
end
