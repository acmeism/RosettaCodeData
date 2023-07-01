import "graphics" for Canvas, Color, ImageData
import "dome" for Window
import "math" for Math

class PlasmaEffect {
    construct new(width, height) {
        Window.title = "Plasma Effect"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _bmp = ImageData.create("plasma_effect", _w, _h)
        _plasma = createPlasma() // stores the hues for the colors
    }

    init() {
        _frame = 0
        _hueShift = 0
        Canvas.cls(Color.white)
    }

    createPlasma() {
        var buffer = List.filled(_w, null)
        for (x in 0..._w) {
            buffer[x] = List.filled(_h, 0)
            for (y in 0..._h) {
                var value = Math.sin(x / 16)
                value = value + Math.sin(y / 8)
                value = value + Math.sin((x + y) / 16)
                value = value + Math.sin((x * x + y * y).sqrt / 8)
                value = value + 4  // shift range from -4 .. 4 to 0 .. 8
                value = value / 8  // bring range down to 0 .. 1
                if (value < 0 || value > 1) Fiber.abort("Hue value out of bounds")
                buffer[x][y] = value
                pset(x, y, Color.hsv(value * 360, 1, 1))
            }
        }
        return buffer
    }

    pset(x, y, col) { _bmp.pset(x, y, col) }

    pget(x, y) { _bmp.pget(x, y) }

    update() {
        _frame = _frame + 1
        if (_frame % 3 == 0) {  // update every 3 frames or 1/20th second
            _hueShift = (_hueShift + 0.02) % 1
        }
    }

    draw(alpha) {
        for (x in 0..._w) {
            for (y in 0..._h) {
                var hue = (_hueShift + _plasma[x][y]) % 1
                var col = Color.hsv(hue * 360, 1, 1)
                pset(x, y, col)
            }
        }
        _bmp.draw(0, 0)
    }
}

var Game = PlasmaEffect.new(640, 640)
