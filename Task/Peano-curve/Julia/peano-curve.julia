using Gtk, Graphics, Colors

function peano(ctx, x, y, lg, i1, i2)
    if lg < 3
        line_to(ctx, x - 250, y - 250)
        stroke(ctx)
        move_to(ctx, x - 250 , y - 250)
    else
        lg = div(lg,  3)
        peano(ctx, x + (2 * i1 * lg), y + (2 * i1 * lg), lg, i1, i2)
        peano(ctx, x + ((i1 - i2 + 1) * lg), y + ((i1 + i2) * lg), lg, i1, 1 - i2)
        peano(ctx, x + lg, y + lg, lg, i1, 1 - i2)
        peano(ctx, x + ((i1 + i2) * lg), y + ((i1 - i2 + 1) * lg), lg, 1 - i1, 1 - i2)
        peano(ctx, x + (2 * i2 * lg), y + ( 2 * (1-i2) * lg), lg, i1, i2)
        peano(ctx, x + ((1 + i2 - i1) * lg), y + ((2 - i1 - i2) * lg), lg, i1, i2)
        peano(ctx, x + (2 * (1 - i1) * lg), y + (2 * (1 - i1) * lg), lg, i1, i2)
        peano(ctx, x + ((2 - i1 - i2) * lg), y + ((1 + i2 - i1) * lg), lg, 1 - i1, i2)
        peano(ctx, x + (2 * (1 - i2) * lg), y + (2 * i2 * lg), lg, 1 - i1, i2)
    end
end

const can = @GtkCanvas()
const win = GtkWindow(can, "Peano Curve", 500, 500)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    set_source(ctx, colorant"blue")
    set_line_width(ctx, 1)
    peano(ctx, w/2, h/2, 500, 0, 0)
end

show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
