import "dome" for Window, Process
import "graphics" for Canvas, Color
import "math" for Math
import "input" for Mouse

var Degrees3 = Num.pi / 60
var Rate = 1

class AnimatedSpinners {
    construct new(width, height) {
        Window.title = "Animated spinners"
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.darkgray)
        _w = width
        _h = height
        _r = 60
        _dx = [0, -180, 180, -180, 180]
        _dy = [0, -180, -180, 180, 180]
        _cols = [Color.green, Color.red, Color.white, Color.yellow, Color.brown]
    }

    drawHand(cx, cy, angle, color) {
        var x = cx + (_r * Math.cos(angle)).truncate
        var y = cy + (_r * Math.sin(angle)).truncate
        Canvas.line(cx, cy, x, y, color, 2)
    }

    init() {
        _frame = 0
        _cx = _w / 2
        _cy = _h / 2
        Canvas.circlefill(_cx, _cy, _cx - 20, Color.black)
        for (i in 0..4) drawHand(_cx + _dx[i], _cy + _dy[i], 0, _cols[i])
    }

    update() {
        _frame = _frame + 1
        if (_frame == 120) _frame = 0
    }

    draw(dt) {
        var angle = Degrees3 * _frame * Rate
        Canvas.cls(Color.darkgray)
        Canvas.circlefill(_w/2, _h/2, _w/2 - 20, Color.black)

        // Move the spinner left or right with the horizontal mouse  position
        if (Mouse.y > _cy - _r && Mouse.y < _cy + _r) {
            if (Mouse.x > _cx && Mouse.x < _cx + _r) _cx = _cx - 10
            if (Mouse.x < _cx && Mouse.x > _cx - _r) _cx = _cx + 10
        }

        // Move the spinner up or down with the vertical mouse position
        if (Mouse.x > _cx - _r && Mouse.x < _cx + _r) {
            if (Mouse.y > _cy && Mouse.y < _cy + _r) _cy = _cy - 10
            if (Mouse.y < _cy && Mouse.y > _cy - _r) _cy = _cy + 10
        }

        // Ensure the center spinner is always visible
        if (_cx < _r) _cx = _cx + _r
        if (_cx > _w - _r)_cx = _cx - _r
        if (_cy < _r) _cy = _cy + _r
        if (_cy > _h - _r) _cy = _cy - _r

        for (i in 0..4) drawHand(_cx + _dx[i], _cy + _dy[i], angle, _cols[i])
    }
}

// Pass Rate as a command line argument to speed up the spinner, otherwise 1 is used
if (Process.args.count == 3) Rate = Num.fromString(Process.args[2])
var Game = AnimatedSpinners.new(800, 800)
