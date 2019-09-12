using Gtk, Colors, PerceptualColourMaps

function munchingsquares(ctx, w, h)
    extent = min(max(w, h), 256)
    colors = cmap("R1", N=extent)
    for i in 1:2:w-2, j in 1:2:h-2
        rectangle(ctx, i, j, i + 2, j + 2)
        c = colors[((UInt(i) ^ UInt(j)) % extent) + 1]
        set_source_rgb(ctx, red(c), blue(c), green(c))
        fill(ctx)
    end
end

const can = @GtkCanvas()
const win = GtkWindow(can, "Munching Squares", 720, 360)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    munchingsquares(ctx, w, h)
end

show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
