import "graphics" for Canvas, Color
import "dome" for Window
import "random" for Random

var Rand = Random.new()

class BarnsleyFern {
    construct new(width, height, points) {
        Window.title = "Barnsley Fern"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _n = points
    }

    init() {
        createFern()
    }

    createFern() {
        var x = 0
        var y = 0
        var c = Color.hex("#32cd32")
        for (i in 0..._n) {
            var tx
            var ty
            var r = Rand.float()
            if (r <= 0.01) {
                tx = 0
                ty = 0.16 * y
            } else if (r <= 0.86) {
                tx =  0.85 * x + 0.04 * y
                ty = -0.04 * x + 0.85 * y + 1.6
            } else if (r <= 0.93) {
                tx = 0.2  * x - 0.26 * y
                ty = 0.23 * x + 0.22 * y + 1.6
            } else {
                tx = -0.15 * x + 0.28 * y
                ty =  0.26 * x + 0.24 * y + 0.44
            }
            x = tx
            y = ty
            Canvas.pset((_w/2 + x * _w/11).round, (_h - y * _h/11).round, c)
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = BarnsleyFern.new(640, 640, 200000)
