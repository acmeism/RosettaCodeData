import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

class XiaolinWu {
    construct new(width, height) {
        Window.title = "Xiaolin Wu's line algorithm"
        Window.resize(width, height)
        Canvas.resize(width, height)
    }

    init() {
        Canvas.cls(Color.white)
        drawLine(550, 170, 50, 435)
    }

    plot(x, y, c) {
        var col = Color.rgb(0, 0, 0, c * 255)
        x = ipart(x)
        y = ipart(y)
        Canvas.ellipsefill(x, y, x + 2, y + 2, col)
    }

    ipart(x) { x.truncate }

    fpart(x) { x.fraction }

    rfpart(x) { 1 - fpart(x) }

    drawLine(x0, y0, x1, y1) {
        var steep = Math.abs(y1 - y0) > Math.abs(x1 - x0)
        if (steep) drawLine(y0, x0, y1, x1)
        if (x0 > x1) drawLine(x1, y1, x0, y0)
        var dx = x1 - x0
        var dy = y1 - y0
        var gradient = dy / dx

        // handle first endpoint
        var xend = Math.round(x0)
        var yend = y0 + gradient * (xend - x0)
        var xgap = rfpart(x0 + 0.5)
        var xpxl1 = xend  // this will be used in the main loop
        var ypxl1 = ipart(yend)

        if (steep) {
            plot(ypxl1, xpxl1, rfpart(yend) * xgap)
            plot(ypxl1 + 1, xpxl1, fpart(yend) * xgap)
        } else {
            plot(xpxl1, ypxl1, rfpart(yend) * xgap)
            plot(xpxl1, ypxl1 + 1, fpart(yend) * xgap)
        }

        // first y-intersection for the main loop
        var intery = yend + gradient

        // handle second endpoint
        xend = Math.round(x1)
        yend = y1 + gradient * (xend - x1)
        xgap = fpart(x1 + 0.5)
        var xpxl2 = xend  // this will be used in the main loop
        var ypxl2 = ipart(yend)

        if (steep) {
            plot(ypxl2, xpxl2, rfpart(yend) * xgap)
            plot(ypxl2 + 1, xpxl2, fpart(yend) * xgap)
        } else {
            plot(xpxl2, ypxl2, rfpart(yend) * xgap)
            plot(xpxl2, ypxl2 + 1, fpart(yend) * xgap)
        }

        // main loop
        var x = xpxl1 + 1
        while (x <= xpxl2 - 1) {
            if (steep) {
                plot(ipart(intery), x, rfpart(intery))
                plot(ipart(intery) + 1, x, fpart(intery))
            } else {
                plot(x, ipart(intery), rfpart(intery))
                plot(x, ipart(intery) + 1, fpart(intery))
            }
            intery = intery + gradient
            x = x + 1
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = XiaolinWu.new(640, 640)
