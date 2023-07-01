import "dome" for Window
import "graphics" for Canvas, Color
import "math" for Point
import "random" for Random
import "./dynamic" for Tuple
import "./seq" for Stack

var ColoredPoint = Tuple.create("ColoredPoint", ["x", "y", "colorIndex"])

class ChaosGame {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Chaos game"
        _width = width
        _height = height
        _stack = Stack.new()
        _points = null
        _colors = [Color.red, Color.green, Color.blue]
        _r = Random.new()
    }

    init() {
        Canvas.cls(Color.white)
        var margin = 60
        var size = _width - 2 * margin
        _points = [
            Point.new((_width/2).floor, margin),
            Point.new(margin, size),
            Point.new(margin + size, size)
        ]
        _stack.push(ColoredPoint.new(-1, -1, 0))
    }

    addPoint() {
        var colorIndex = _r.int(3)
        var p1 = _stack.peek()
        var p2 = _points[colorIndex]
        _stack.push(halfwayPoint(p1, p2, colorIndex))
    }

    drawPoints() {
        for (cp in _stack) {
            var c = _colors[cp.colorIndex]
            Canvas.circlefill(cp.x, cp.y, 1, c)
        }
    }

    halfwayPoint(a, b, idx) { ColoredPoint.new(((a.x + b.x)/2).floor, ((a.y + b.y)/2).floor, idx) }

    update() {
        if (_stack.count < 50000) {
            for (i in 0...25) addPoint()
        }
    }

    draw(alpha) {
        drawPoints()
    }
}

var Game = ChaosGame.new(640, 640)
