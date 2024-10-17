using Gtk, Graphics

const can = @GtkCanvas()
const win = GtkWindow(can, "Draw a Pixel", 320, 240)

draw(can) do widget
    ctx = getgc(can)
    set_source_rgb(ctx, 255, 0, 0)
    move_to(ctx, 100, 100)
    line_to(ctx, 101,100)
    stroke(ctx)
end

show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
