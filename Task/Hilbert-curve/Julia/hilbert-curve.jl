using Gtk, Graphics, Colors

Base.isless(p1::Vec2, p2::Vec2) = (p1.x == p2.x ? p1.y < p2.y : p1.x < p2.x)

struct Line
	p1::Point
	p2::Point
end

dist(p1, p2) = sqrt((p2.y - p1.y)^2 + (p2.x - p1.x)^2)
length(ln::Line) = dist(ln.p1, ln.p2)
isvertical(line) = (line.p1.x == line.p2.x)
ishorizontal(line) = (line.p1.y == line.p2.y)

const colorseq = [colorant"blue", colorant"red", colorant"green"]
const linewidth = 1
const toporder = 3

function drawline(ctx, p1, p2, color, width)
    move_to(ctx, p1.x, p1.y)
    set_source(ctx, color)
    line_to(ctx, p2.x, p2.y)
    set_line_width(ctx, width)
    stroke(ctx)
end
drawline(ctx, line, color, width=linewidth) = drawline(ctx, line.p1, line.p2, color, width)

function hilbertmutateboxes(ctx, line, order, maxorder=toporder)
    if line.p1 < line.p2
        p1, p2 = line.p1, line.p2
    else
        p2, p1 = line.p1, line.p2
    end
    color = colorseq[order % 3 + 1]
	d = dist(p1, p2) / 3
    if ishorizontal(line)
        pl = Point(p1.x + d, p1.y)
        plu = Point(p1.x + d, p1.y - d)
        pld = Point(p1.x + d, p1.y + d)
        pr = Point(p2.x - d, p2.y)
        pru = Point(p2.x - d, p2.y - d)
        prd = Point(p2.x - d, p2.y + d)
        lines = [Line(plu, pl), Line(plu, pru), Line(pru, pr),
                 Line(pr, prd), Line(pld, prd), Line(pld, pl)]
    else # vertical
        pu = Point(p1.x, p1.y + d)
        pul = Point(p1.x - d, p1.y + d)
        pur = Point(p1.x + d, p1.y + d)
        pd = Point(p2.x, p2.y - d)
        pdl = Point(p2.x - d, p2.y - d)
        pdr = Point(p2.x + d, p2.y - d)
        lines = [Line(pul, pu), Line(pul, pdl), Line(pdl, pd),
                 Line(pu, pur), Line(pur, pdr), Line(pd, pdr)]
    end
    for li in lines
        drawline(ctx, li, color)
    end
    if order <= maxorder
        for li in lines
            hilbertmutateboxes(ctx, li, order + 1, maxorder)
        end
    end
end


const can = @GtkCanvas()
const win = GtkWindow(can, "Hilbert 2D", 400, 400)

@guarded draw(can) do widget
    ctx = getgc(can)
    h = height(can)
    w = width(can)
    line = Line(Point(0, h/2), Point(w, h/2))
    drawline(ctx, line, colorant"black", 2)
    hilbertmutateboxes(ctx, line, 0)
end


show(can)
const cond = Condition()
endit(w) = notify(cond)
signal_connect(endit, win, :destroy)
wait(cond)
