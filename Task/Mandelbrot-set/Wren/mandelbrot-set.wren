import "graphics" for Canvas, Color
import "dome" for Window

var MaxIters = 570
var Zoom = 150

class MandelbrotSet {
    construct new(width, height) {
        Window.title = "Mandelbrot Set"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        createMandelbrot()
    }

    createMandelbrot() {
        for (x in 0..._w) {
            for (y in 0..._h) {
                var zx = 0
                var zy = 0
                var cX = (x - 400) / Zoom
                var cY = (y - 300) / Zoom
                var i = MaxIters
                while (zx * zx + zy * zy < 4 && i > 0) {
                    var tmp = zx * zx - zy * zy + cX
                    zy = 2 * zx * zy + cY
                    zx = tmp
                    i = i - 1
                }
                var r = i * 255 / MaxIters
                Canvas.pset(x, y, Color.rgb(r, r, r))
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = MandelbrotSet.new(800, 600)
