import "graphics" for Canvas, Color
import "dome" for Window, Process
import "math" for Math
import "font" for Font
import "input" for Mouse, Keyboard
import "random" for Random
import "./polygon" for Polygon

var Rand = Random.new()

class Hexagon is Polygon {
    static baseColor { Color.yellow }
    static selectedColor { Color.pink }

    construct new(x, y, halfWidth, letter) {
        _x = x
        _y = y
        _letter = letter
        var vertices = List.filled(6, null)
        for (i in 0..5) {
            var vx = x + halfWidth * Math.cos(i * Num.pi / 3)
            var vy = y + halfWidth * Math.sin(i * Num.pi / 3)
            vertices[i] = [vx, vy]
        }
        super(vertices, "")
        _selected = false
    }

    letter { _letter }
    selected { _selected }
    selected=(v) { _selected = v }

    draw() {
        var col = selected ? Hexagon.selectedColor : Hexagon.baseColor
        drawfill(col)
        super.draw(Color.black)
        col = selected ? Color.black : Color.red
        Canvas.print(_letter, _x - 8, _y - 8, col)
    }
}

class Honeycombs {
    construct new(width, height) {
        Window.title = "Honeycombs"
        Window.resize(width, height)
        Canvas.resize(width, height)
        var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toList
        Rand.shuffle(letters)
        _letters = letters[0..19]
        _x1 = 150
        _y1 = 100
        _x2 = 225
        _y2 = 143
        _w  = 150
        _h  = 87
        _hs = null
        _comb = List.filled(20, null)
        Font.load("memory", "memory.ttf", 48)
        Font["memory"].antialias = true
        Canvas.font = "memory"
    }

    drawHexagons() {
         for (i in 0..._comb.count) {
            var x
            var y
            if (i < 12) {
                x = _x1 + (i % 3) * _w
                y = _y1 + (i / 3).floor * _h
            } else {
                x = _x2 + (i % 2) * _w
                y = _y2 + ((i - 12) / 2).floor * _h
            }
            _comb[i] = Hexagon.new(x, y, (_w / 3).floor, _letters[i])
            _comb[i].draw()
        }
    }

    allSelected() { _comb.all { |h| h.selected } }

    init() {
        drawHexagons()
    }

    update() {
        _hs = null
        if (Mouse.isButtonPressed("left")) {
            for (h in _comb) {
                if (h.contains(Mouse.position.x, Mouse.position.y)) {
                    _hs = h
                    break
                }
            }
        } else if (Keyboard.allPressed.count > 0) {
            for (h in _comb) {
                if (Keyboard.isKeyDown(h.letter)) {
                    _hs = h
                    break
                }
            }
        }
    }

    draw(alpha) {
        if (_hs) {
            _hs.selected = true
            _hs.draw()
            if (allSelected()) Process.exit(0)
        }
    }
}

var Game = Honeycombs.new(600, 500)
