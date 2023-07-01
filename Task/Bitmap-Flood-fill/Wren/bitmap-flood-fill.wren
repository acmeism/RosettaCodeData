import "graphics" for Canvas, ImageData, Color
import "dome" for Window
import "input" for Keyboard

class Bitmap {
    construct new(name, size) {
        Window.title = name
        Window.resize(size, size)
        Canvas.resize(size, size)
        size = size / 2
        _bmp = ImageData.create(name, size, size)
        _size = size
        _flooded = false
    }

    init() {
        var s = _size
        var hs = s / 2
        var qs = s / 4
        fill(0, 0, s, s, Color.yellow)
        fill(qs, qs, 3 * qs, 3 * qs, Color.red)
        fill(qs * 1.5, qs * 1.5, qs * 2.5, qs * 2.5, Color.white)
        _bmp.draw(hs, hs)
    }

    fill(s, t, w, h, col) {
        for (x in s...w) {
            for (y in t...h) pset(x, y, col)
        }
    }

    flood(x, y, repl) {
        var target = pget(x, y)
        var ff // recursive closure
        ff = Fn.new { |x, y|
            if (x >= 0 && x < _bmp.width && y >= 0 && y < _bmp.height) {
                var p = pget(x, y)
                if (p.r == target.r && p.g == target.g && p.b == target.b) {
                    pset(x, y, repl)
                    ff.call(x-1, y)
                    ff.call(x+1, y)
                    ff.call(x, y-1)
                    ff.call(x, y+1)
                }
            }
        }
        ff.call(x, y)
    }

    pset(x, y, col) { _bmp.pset(x, y, col) }

    pget(x, y) { _bmp.pget(x, y) }

    update() {
        var hs = _size / 2
        var qs = _size / 4
        if (!_flooded && Keyboard.isKeyDown("up")) {
           flood(qs, qs, Color.blue)
           _bmp.draw(hs, hs)
           _flooded = true
        } else if (_flooded && Keyboard.isKeyDown("down")) {
           flood(qs, qs, Color.red)
           _bmp.draw(hs, hs)
           _flooded = false
        }
    }

    draw(alpha) {}
}

var Game = Bitmap.new("Bitmap - flood fill", 600)
