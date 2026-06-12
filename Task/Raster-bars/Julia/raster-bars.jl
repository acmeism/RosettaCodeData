using Colors, Cairo, Gtk

const can = GtkCanvas()
const win = GtkWindow(can, "Raster Bar Demo", 500, 500)
const pallete_index = [1]
const horizontal = [true]
const palette = [  # colors from the Go example
    colorant"rgba(166, 124, 0, 1.0)",
    colorant"rgba(191, 155, 48, 1.0)",
    colorant"rgba(255, 191, 0, 1.0)",
    colorant"rgba(255, 207, 64, 1.0)",
    colorant"rgba(255, 220, 115, 1.0)",
]

function line(ctx, x1, y1, x2, y2, colr, width=1)
    set_source(ctx, colr)
    set_line_width(ctx, width)
    move_to(ctx, x1, y1)
    line_to(ctx, x2, y2)
    stroke(ctx)
end
hline(ctx, x1, y, x2, c) = line(ctx, x1, y, x2, y, c)
hbar(ctx, x1, y1, x2, y2, c) = foreach(y -> hline(ctx, x1, y, x2, c), y1:y2)
vline(ctx, x, y1, y2, c) = line(ctx, x, y1, x, y2, c)
vbar(ctx, x1, y1, x2, y2, c) = foreach(x -> vline(ctx, x, y1, y2, c), x1:x2)

draw(can) do widget
    ctx = Gtk.getgc(can)
    height, width = Gtk.height(can), Gtk.width(can)
    if horizontal[1]
        for i in 1:3:height
            hbar(ctx, 0, i, width, i + 3, palette[pallete_index[1]])
            pallete_index[1] = mod1(pallete_index[1] + 1, 5)
        end
    else
        for i in 1:3:width
            vbar(ctx, i, 0, i + 3, height, palette[pallete_index[1]])
            pallete_index[1] = mod1(pallete_index[1] + 1, 5)
        end
    end
end

set_gtk_property!(can, :expand, true)
for i in 1:typemax(Int)
    sleep(0.1)
    draw(can)
    showall(win)
    pallete_index[1] = mod1(pallete_index[1] + 2, 5)
    if i % 30 == 29
        horizontal[1] = !horizontal[1]
    end
end
