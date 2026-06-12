import "dome" for Window
import "graphics" for Canvas, Color

var c0 = Color.rgb(166, 124,   0, 255)
var c1 = Color.rgb(191, 155,  48, 255)
var c2 = Color.rgb(255, 191,   0, 255)
var c3 = Color.rgb(255, 207,  64, 255)
var c4 = Color.rgb(255, 220, 115, 255)

var Palette = [c0, c1, c2, c3, c4]

class RasterBars {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Raster bars"
        _width = width
        _height = height
    }

    init() {
        _f = 0
        _nframes = 320
        _draw = false
        _c = false
    }

    hline(x1, y, x2, ci) {
        while (x1 <= x2) {
            Canvas.pset(x1, y, Palette[ci])
            x1 = x1 + 1
        }
    }

    vline(x, y1, y2, ci) {
        while (y1 <= y2) {
            Canvas.pset(x, y1, Palette[ci])
            y1 = y1 + 1
        }
    }

    drawHBar(x1, y1, x2, y2, ci) {
        while (y1 <= y2) {
            hline(x1, y1, x2, ci)
            y1 = y1 + 1
        }
    }

    drawVBar(x1, y1, x2, y2, ci) {
        while (x1 <= x2) {
            vline(x1, y1, y2, ci)
            x1 = x1 + 1
        }
    }

    update() {
        _f = _f + 1
        if (_f % 8 == 0) {
            _draw = true
            _c = !_c
        } else {
            _draw = false
        }
        if (_f == _nframes) _f = 0
    }

    draw(alpha) {
        if (!_draw) return
        var c = _c ? 0 : 1
        if (_f < _nframes / 2) {
            var y = 0
            while (y < _height) {
                drawHBar(0, y, _width, y+19, c)
                c = (c < 4) ? c + 1 : 0
                y = y + 20
            }
        } else {
            var x = 0
            while (x < _width) {
                drawVBar(x, 0, x+19, _height, c)
                c = (c < 4) ? c + 1 : 0
                x = x + 20
            }
        }
    }
}

var Game = RasterBars.new(500, 500)
