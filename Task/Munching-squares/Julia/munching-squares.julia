using Gtk, Cairo

const can = @GtkCanvas()
const win = GtkWindow(can, "Munching Squares", 512, 512)

@guarded draw(can) do widget
    ctx = getgc(can)
    for x in 0:255, y in 0:255
        set_source_rgb(ctx, abs(255 - x - y) / 255, ((255 - x) ⊻ y) / 255, (x ⊻ (255 - y)) / 255)
        circle(ctx, 2x, 2y, 2)
        fill(ctx)
    end
end

show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
