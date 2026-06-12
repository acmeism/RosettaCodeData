import "dome" for Window
import "graphics" for Canvas, Color, Font
import "input" for Keyboard
import "random" for Random
import "math" for Math
import "./polygon" for Polygon

var Palette = [
    Color.purple,
    Color.darkblue,
    Color.darkpurple,
    Color.darkgreen,
    Color.brown,
    Color.darkgray,
    Color.lightgray,
    Color.red,
    Color.orange,
    Color.yellow,
    Color.green,
    Color.blue,
    Color.indigo,
    Color.pink,
    Color.peach,
    Color.white
]

var Rand = Random.new()

class FifteenPuzzle3d {
    construct new() {
        Window.resize(960, 840)
        Canvas.resize(960, 840)
        Window.title = "15-puzzle game using 3D cubes"
        _radius = Canvas.height / 14
        // see Go-fonts page
        Font.load("Go-Regular20", "Go-Regular.ttf", 20)
        Canvas.font = "Go-Regular20"
        _blank = 15
        _moves = 0
        _gameOver = false
    }

    init() {
        _centers = List.filled(16, null)
        _cubes = List.filled(15, 0)
        for (i in 0..14) _cubes[i] = i
        Rand.shuffle(_cubes)
        _cubes.add(15)
        var x = Canvas.width / 10
        var y = _radius
        for (i in 0..3) {
            var cx = 2 * x * (i + 1)
            for (j in 0..3) {
                var cy = (x + y) * (j + 1)
                _centers[j * 4 + i] = [cx, cy]
            }
        }
        for (i in 0..15) drawCube(_cubes[i], i)
    }

    drawCube(n, pos) {
        var cx = _centers[pos][0]
        var cy = _centers[pos][1]
        var angle = Num.pi / 6
        var incr = 2 * angle
        var hexagon = Polygon.regular(6, cx, cy, _radius, 90)
        hexagon.drawfill(Palette[n])
        for (i in [1, 3, 5]) {
            var vx = (_radius * Math.cos(angle + i*incr) + cx).floor
            var vy = (_radius * Math.sin(angle + i*incr) + cy).floor
            Canvas.line(cx, cy, vx, vy, Color.black)
        }
        var ns = (n < 15 || _gameOver) ? (n + 1).toString : ""
        var hr  = _radius * 0.5
        var er  = _radius * 0.125
        var tqr = _radius * 0.75
        Canvas.print(ns, cx + hr - er, cy, Color.white)
        Canvas.print(ns, cx - hr - er, cy, Color.white)
        Canvas.print(ns, cx - er, cy - tqr, Color.white)
    }

    completed {
        for (i in 0..15) {
            if (_cubes[i] != i) return false
        }
        Palette[15] = Color.rgb(255, 215, 0) // gold
        return true
    }

    update() {
        var changed = false
        if (Keyboard["Left"].justPressed) {
            if (_blank%4 != 0) {
                _cubes.swap(_blank, _blank-1)
                _blank = _blank - 1
                _moves =_moves + 1
                changed = true
            }
        } else if (Keyboard["Right"].justPressed) {
            if ((_blank+1)%4 != 0) {
                _cubes.swap(_blank, _blank+1)
                _blank = _blank + 1
                _moves = _moves + 1
                changed = true
            }
        } else if (Keyboard["Up"].justPressed) {
            if (_blank > 3) {
                _cubes.swap(_blank, _blank-4)
                _blank = _blank - 4
                _moves = _moves + 1
                changed = true
            }
        } else if (Keyboard["Down"].justPressed) {
            if (_blank < 12) {
                _cubes.swap(_blank, _blank+4)
                _blank = _blank + 4
                _moves = _moves + 1
                changed = true
            }
        }
        if (changed) {
            Canvas.cls(Color.black)
            _gameOver = completed
            for (i in 0..15) drawCube(_cubes[i], i)
            if (!_gameOver) {
                var m = "Moves = %(_moves)"
                Canvas.print(m, 0.4 * Canvas.width, 13 * _radius, Color.white)
            } else {
                var m = "You've completed the puzzle in %(_moves) moves!"
                Canvas.print(m, 0.3 * Canvas.width, 13 * _radius, Color.white)
            }
        }
    }

    draw(alpha) {}
}

var Game = FifteenPuzzle3d.new()
