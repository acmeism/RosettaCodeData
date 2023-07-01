import "graphics" for Canvas, Color
import "dome" for Window

var MaxIters = 300
var Zoom = 1
var MoveX = 0
var MoveY = 0
var CX = -0.7
var CY = 0.27015

class JuliaSet {
    construct new(width, height) {
        Window.title = "Julia Set"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        Canvas.cls(Color.white)
        createJulia()
    }

    createJulia() {
        for (x in 0..._w) {
            for (y in 0..._h) {
                var zx = 1.5 * (x - _w / 2) / (0.5 * Zoom * _w) + MoveX
                var zy = (y - _h / 2) / (0.5 * Zoom * _h) + MoveY
                var i = MaxIters
                while (zx * zx + zy * zy < 4 && i > 0) {
                    var tmp = zx * zx - zy * zy + CX
                    zy = 2 * zx * zy + CY
                    zx = tmp
                    i = i - 1
                }
                var c = Color.rgb(i % 256, i % 256, (i*8) % 256)
                Canvas.pset(x, y, c)
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = JuliaSet.new(800, 600)
