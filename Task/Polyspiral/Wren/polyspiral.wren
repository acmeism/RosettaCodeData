import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

var Radians = Fn.new { |d| d * Num.pi / 180 }

class Polyspiral {
    construct new(width, height) {
        Window.title = "Polyspiral"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _inc = 0
    }

    init() {
        drawSpiral(5, Radians.call(_inc))
    }

    drawSpiral(length, angleIncrement) {
        Canvas.cls(Color.white)
        var x1 = _w / 2
        var y1 = _h / 2
        var len = length
        var angle = angleIncrement
        for (i in 0...150) {
            var col = Color.hsv(i / 150 * 360, 1, 1)
            var x2 = x1 + Math.cos(angle) * len
            var y2 = y1 - Math.sin(angle) * len
            Canvas.line(x1.truncate, y1.truncate, x2.truncate, y2.truncate, col)
            x1 = x2
            y1 = y2
            len = len + 3
            angle = (angle + angleIncrement) % (Num.pi * 2)
        }
    }

    update() {
        _inc = (_inc + 0.05) % 360
    }

    draw(alpha) {
        drawSpiral(5, Radians.call(_inc))
    }
}

var Game = Polyspiral.new(640, 640)
