using Gtk, Cairo

const can = GtkCanvas(800, 100)
const win = GtkWindow(can, "Canvas")
const numbers = [0, 1, 20, 300, 4000, 5555, 6789, 8123]

function drawcnum(ctx, xypairs)
    move_to(ctx, xypairs[1][1], xypairs[1][2])
    for p in xypairs[2:end]
        line_to(ctx, p[1], p[2])
    end
    stroke(ctx)
end

@guarded draw(can) do widget
    ctx = getgc(can)
    hlen, wlen, len = height(can), width(can), length(numbers)
    halfwspan, thirdcolspan, voffset = wlen ÷ (len * 2), wlen ÷ (len * 3), hlen ÷ 8
    set_source_rgb(ctx, 0, 0, 2550)
    for (i, n) in enumerate(numbers)
        # paint vertical as width 2 rectangle
        x = halfwspan * (2 * i - 1)
        rectangle(ctx, x, voffset, 2, hlen - 2 * voffset)
        stroke(ctx)
        # determine quadrant and draw numeral lines there
        dig = [(10^(i - 1), m) for (i, m) in enumerate(digits(n))]
        for (d, m) in dig
            y, dx, dy = (d == 1) ? (voffset, thirdcolspan, thirdcolspan) :
                (d == 10) ? (voffset, -thirdcolspan, thirdcolspan) :
                (d == 100) ? (hlen - voffset, thirdcolspan, -thirdcolspan) :
                (hlen - voffset, -thirdcolspan, -thirdcolspan)
            m == 1 && drawcnum(ctx, [[x, y], [x + dx, y]])
            m == 2 && drawcnum(ctx, [[x, y + dy], [x + dx, y + dy]])
            m == 3 && drawcnum(ctx, [[x, y], [x + dx, y + dy]])
            m == 4 && drawcnum(ctx, [[x, y + dy], [x + dx, y]])
            m == 5 && drawcnum(ctx, [[x, y + dy], [x + dx, y], [x, y]])
            m == 6 && drawcnum(ctx, [[x + dx, y], [x + dx, y + dy]])
            m == 7 && drawcnum(ctx, [[x, y], [x + dx, y], [x + dx, y + dy]])
            m == 8 && drawcnum(ctx, [[x, y + dy], [x + dx, y + dy], [x + dx, y]])
            m == 9 && drawcnum(ctx, [[x, y], [x + dx, y], [x + dx, y + dy], [x, y + dy]])
        end
        move_to(ctx, x - halfwspan ÷ 6, hlen - 4)
        Cairo.show_text(ctx, string(n))
        stroke(ctx)
    end
end

function mooncipher()
    draw(can)
    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    show(can)
    wait(cond)
end

mooncipher()
