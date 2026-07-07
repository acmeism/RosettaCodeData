import "dome" for Window
import "graphics" for Canvas, Color

// Parameters.
var Sigma = 10
var Rho = 28
var Beta = 8 / 3

class LorenzAttractor {
    construct new(width, height) {
        Window.title = "Lorenz Attractor"
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.black)
        _clr = Color.rgb(0, 200, 255, 255)
    }

    init() {
        // Starting position and time step.
        _x = 0.01
        _y = 0
        _z = 0
        _dt = 0.01

        // Screen and zoom settings.
        _scale = 7
        _offsetX = 400
        _offsetY = 300

        // List of points to draw
        _points = []
    }

    update() {
        var dx = Sigma * (_y - _x) * _dt
        var dy = (_x * (Rho - _z) - _y) * _dt
        var dz = (_x * _y - Beta * _z) * _dt

        _x = _x + dx
        _y = _y + dy
        _z = _z + dz

        // Scale point to screen.
        var screenX = _x * _scale + _offsetX
        var screenY = _y * _scale + _offsetY
        _points.add([screenX, screenY])

        // Limit points to a maximum of 2000 to avoid stuttering.
        if (_points.count > 2000) { _points.removeAt(0) }
    }

    draw(dt) {
        // Draw lines between all the coordinates stored so far.
        if (_points.count > 1) {
            for (i in 0..._points.count - 1) {
                var x1 = _points[i][0]
                var y1 = _points[i][1]
                var x2 = _points[i + 1][0]
                var y2 = _points[i + 1][1]
                Canvas.line(x1, y1, x2, y2, _clr)
            }
        }
    }
}

var Game = LorenzAttractor.new(800, 600)
