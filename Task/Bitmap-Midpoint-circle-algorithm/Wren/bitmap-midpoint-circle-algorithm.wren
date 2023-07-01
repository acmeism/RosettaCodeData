import "graphics" for Canvas, Color, ImageData
import "dome" for Window

class MidpointCircle {
    construct new(width, height) {
        Window.title = "Midpoint Circle"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _bmp = ImageData.create("midpoint circle", width, height)
    }

    init() {
        fill(Color.pink)
        drawCircle(200, 200, 100, Color.black)
        drawCircle(200, 200,  50, Color.white)
        _bmp.draw(0, 0)
    }

    fill(col) {
        for (x in 0..._w) {
            for (y in 0..._h) pset(x, y, col)
        }
    }

    drawCircle(centerX, centerY, radius, circleColor) {
        var d = ((5 - radius * 4)/4).truncate
        var x = 0
        var y = radius
        while (true) {
            pset(centerX + x, centerY + y, circleColor)
            pset(centerX + x, centerY - y, circleColor)
            pset(centerX - x, centerY + y, circleColor)
            pset(centerX - x, centerY - y, circleColor)
            pset(centerX + y, centerY + x, circleColor)
            pset(centerX + y, centerY - x, circleColor)
            pset(centerX - y, centerY + x, circleColor)
            pset(centerX - y, centerY - x, circleColor)
            if (d < 0) {
                d = d + 2 * x + 1
            } else {
                d = d + 2 * (x - y) + 1
                y = y - 1
            }
            x = x + 1
            if (x > y) break
        }
    }

    pset(x, y, col) { _bmp.pset(x, y, col) }

    pget(x, y) { _bmp.pget(x, y) }

    update() {}

    draw(alpha) {}
}

var Game = MidpointCircle.new(400, 400)
