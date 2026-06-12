import "graphics" for Canvas, Color
import "dome" for Window

var Palette = [
    Color.red, Color.green, Color.blue, Color.orange,
    Color.indigo, Color.pink, Color.yellow, Color.white
]

class VibratingRectangles {
    construct new(width, height) {
        Window.title = "Vibrating Rectangles"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        _c = 0
        _r = 0
        _frame = 0
    }

    update() {
        _frame = _frame + 1
        if (_frame == 60) _frame = 0
        if (_frame % 15 == 0) {
            _r = _r + 1
            if (_r > 20) {
                _r = 0
                _c = (_c + 1) % 8
            }
        }
    }

    draw(alpha) {
        var x = (_w * (_r + 1) / 50).floor
        var y = (_h * (_r + 1) / 50).floor
        var w = _w - 2 * x
        var h = _h - 2 * y
        Canvas.rect(x, y, w, h, Palette[_c])
    }
}

var Game = VibratingRectangles.new(500, 500)
