import "dome" for Window
import "graphics" for Canvas, Color, Font
import "random" for Random

var Rand = Random.new()

class MatrixDigitalRain {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Matrix digital rain"
        Font.load("Mem12", "memory.ttf", 24)
        Canvas.font = "Mem12"
    }

    letter(x, y, r, g, b) {
        if (y < 0 || y >= _my) return
        var col = Color.rgb(r, g, b)
        var c = String.fromByte(_scr[x][y])
        Canvas.print(c, x * 12.8 , y * 12.8 , col)
    }

    init() {
        _mx = 50
        _my = 42
        _scr = List.filled(_mx, null)
        for (x in 0..._mx) {
            _scr[x] = List.filled(_my, 0)
            for (y in 0..._my) _scr[x][y] = Rand.int(33, 128)
        }
        _ms = 50
        _sx = List.filled(_ms, 0)
        _sy = List.filled(_ms, 0)
    }

    update() {
        for (a in 0..._ms) {
            _sx[a] = Rand.int(_mx)
            _sy[a] = Rand.int(_my)
        }
    }

    draw(alpha) {
        for (s in 0..._ms) {
            var x = _sx[s]
            var y = _sy[s]
            letter(x, y, 0, 255, 0)
            y = y - 1
            letter(x, y, 0, 200, 0)
            y = y - 1
            letter(x, y, 0, 150, 0)
            y = y - 1
            if (y*12.8 + 3 < 0) y = 0
            var c = Color.rgb(0, 0, 0)
            Canvas.rectfill(x*12.8, y*12.8 + 3, 13, 14, c)
            letter(x, y, 0, 70, 0)
            y = y - 24
            if (y*12.8 + 3 < 0) y = 0
            Canvas.rectfill(x*12.8, y*12.8  + 3, 13, 14, c)
        }
        for (s in 0..._ms) {
            if (Rand.int(1, 6) == 1) _sy[s] = _sy[s] + 1
            if (_sy[s] > _my + 25) {
                _sy[s] = 0
                _sx[s] = Rand.int(_mx)
            }
        }
    }
}

var Game = MatrixDigitalRain.new(640, 550)
