import "graphics" for Canvas, ImageData, Color
import "dome" for Window
import "math" for Point

class PlotCoordinates {
    construct new(width, height) {
        Window.title = "Plot coordinates"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _width = width
        _height = height
    }

    init() {
        var x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        var y = [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0]
        plotCoordinates(x, y)
    }

    plotCoordinates(x, y) {
        var n = x.count
        // draw axes
        Canvas.line(40, _height - 40, _width - 40, _height - 40, Color.blue, 2)
        Canvas.line(40, _height - 40, 40, 40, Color.blue, 2)
        var length = 40 * n
        var div = length / 10
        var j = 0
        for (i in 0..9) {
            var p = Point.new(40 + j, _height - 40)
            Canvas.print(i.toString, p.x - 4, p.y + 4, Color.white)
            j = j + div
        }
        j = div
        for (i in 1..9) {
            var p = Point.new(10, _height - 40 - j)
            var s = (i * 20).toString
            if (s.count == 2) s = " " + s
            Canvas.print(s, p.x, p.y, Color.white)
            j = j + div
        }
        Canvas.print("X", _width - 44, _height - 36, Color.green)
        Canvas.print("Y", 20, 40, Color.green)

        // plot points
        var xStart = 40
        var xScale = 40
        var yStart = 40
        var yScale = 2
        var points = List.filled(n, null)
        for (i in 0...n) {
            points[i] = Point.new(xStart + x[i]*xScale, _height - yStart - y[i]*yScale)
        }
        Canvas.circlefill(points[0].x, points[0].y, 3, Color.red)
        for (i in 1...n) {
            Canvas.line(points[i-1].x, points[i-1].y, points[i].x, points[i].y, Color.red)
            Canvas.circlefill(points[i].x, points[i].y, 3, Color.red)
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = PlotCoordinates.new(500, 500)
