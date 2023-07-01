import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math
import "./dynamic" for Tuple

var Element = Tuple.create("Element", ["x", "y"])
var Dt = 0.1
var Angle = Num.pi / 2
var AngleVelocity = 0

class Pendulum {
    construct new(length) {
        Window.title = "Pendulum"
        _w = 2 * length + 50
        _h = length / 2 * 3
        Window.resize(_w, _h)
        Canvas.resize(_w, _h)
        _length = length
        _anchor = Element.new((_w/2).floor, (_h/4).floor)
        _fore = Color.black
    }

    init() {
        drawPendulum()
    }

    drawPendulum() {
        Canvas.cls(Color.white)
        var ball = Element.new((_anchor.x + Math.sin(Angle) * _length).truncate,
                               (_anchor.y + Math.cos(Angle) * _length).truncate)
        Canvas.line(_anchor.x, _anchor.y, ball.x, ball.y, _fore, 2)
        Canvas.circlefill(_anchor.x - 3, _anchor.y - 4, 7, Color.lightgray)
        Canvas.circle(_anchor.x - 3, _anchor.y - 4, 7, _fore)
        Canvas.circlefill(ball.x - 7, ball.y - 7, 14, Color.yellow)
        Canvas.circle(ball.x - 7, ball.y - 7, 14, _fore)
    }

    update() {
        AngleVelocity = AngleVelocity - 9.81 / _length * Math.sin(Angle) * Dt
        Angle = Angle + AngleVelocity * Dt
    }

    draw(alpha) {
        drawPendulum()
    }
}

var Game = Pendulum.new(200)
