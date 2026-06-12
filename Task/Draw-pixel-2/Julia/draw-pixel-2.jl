using Gtk, Graphics

const can = @GtkCanvas()
const win = GtkWindow(can, "Draw a Pixel 2", 640, 480)

draw(can) do widget
    ctx = getgc(can)
    set_source_rgb(ctx, 255, 255, 0)
    x = rand(collect(1:639))
    y = rand(collect(1:480))
    println("The pixel is at $x, $y.")
    move_to(ctx, x, y)
    line_to(ctx, x + 1, y)
    stroke(ctx)
end

draw(can)
show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
