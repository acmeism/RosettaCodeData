using Gtk, Colors, Cairo

function CodepenApp()
    # left-top, top-right, right-bottom, bottom-left
    LT, TR, RB, BL = 1, 2, 3, 4
    edges = [
        [LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
        [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
        [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
        [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT],
        [RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT],
        [RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR],
        [BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR],
        [BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB],
        [LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
        [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
        [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
        [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT]]
    W, B = colorant"white", colorant"darkgray"
    colors = [
        [W, B, B, W],
        [W, W, B, B],
        [B, W, W, B],
        [B, B, W, W]]
    win = GtkWindow("Peripheral drift illusion", 230, 230) |> (can = GtkCanvas())
    @guarded draw(can) do widget
        ctx = Gtk.getgc(can)
        function line(x1, y1, x2, y2, colr)
            set_source(ctx, colr)
            move_to(ctx, x1, y1)
            line_to(ctx, x2, y2)
            stroke(ctx)
        end
        set_source(ctx, colorant"yellow")
        rectangle(ctx, 0, 0, 250, 250)
        fill(ctx)
        set_line_width(ctx, 2)
        for x in 1:12
            px = 18 + x * 14
            for y in 1:12
                py = 18 + y * 14
                set_source(ctx, colorant"skyblue")
                rectangle(ctx, px, py, 10, 10)
                fill(ctx)
                carray = colors[edges[y][x]]
                line(px, py, px + 9, py, carray[1])
                line(px + 9, py, px + 9, py + 9, carray[2])
                line(px + 9, py + 9, px, py + 9, carray[3])
                line(px, py + 9, px, py, carray[4])
            end
        end
    end
    showall(win)
    draw(can)
    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(condition)
end

CodepenApp()
