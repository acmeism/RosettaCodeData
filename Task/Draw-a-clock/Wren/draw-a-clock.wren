import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

var Degrees06 = Num.pi / 30
var Degrees30 = Degrees06 * 5
var Degrees90 = Degrees30 * 3

class Clock {
    construct new(hour, minute, second) {
        Window.title = "Clock"
        _size = 590
        Window.resize(_size, _size)
        Canvas.resize(_size, _size)
        _spacing = 40
        _diameter = _size - 2 * _spacing
        _cx = (_diameter / 2).floor + _spacing
        _cy = _cx
        _hour = hour
        _minute = minute
        _second = second
    }

    drawFace() {
        var radius = (_diameter / 2).floor
        Canvas.circlefill(_cx, _cy, radius, Color.yellow)
        Canvas.circle(_cx, _cy, radius, Color.black)
    }

    drawHand(angle, radius, color) {
        var x = _cx + (radius * Math.cos(angle)).truncate
        var y = _cy - (radius * Math.sin(angle)).truncate
        Canvas.line(_cx, _cy, x, y, color, 2)
    }

    drawClock() {
        Canvas.cls(Color.white)
        drawFace()
        var angle = Degrees90 - Degrees06 * _second
        drawHand(angle, (_diameter/2).floor - 30, Color.red)
        var minsecs = _minute + _second/60
        angle = Degrees90 - Degrees06 * minsecs
        drawHand(angle, (_diameter / 3).floor + 10, Color.black)
        var hourmins = _hour + minsecs / 60
        angle = Degrees90 - Degrees30 * hourmins
        drawHand(angle, (_diameter / 4).floor + 10, Color.black)
    }

    init() {
        _frame = 0
        drawClock()
    }

    update() {
        _frame = _frame + 1
        if (_frame == 60) {
            _frame = 0
            _second = _second + 1
            if (_second == 60) {
               _minute = _minute + 1
               _second = 0
                if (_minute == 60) {
                    _hour = _hour + 1
                    _minute = 0
                    if (_hour == 24) _hour = 0
                }
            }
        }
    }

    draw(alpha) {
        drawClock()
    }
}

var Game = Clock.new(0, 0, 0) // start at midnight
