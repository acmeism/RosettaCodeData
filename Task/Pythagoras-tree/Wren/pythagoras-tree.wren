import "graphics" for Canvas, Color
import "dome" for Window
import "./polygon" for Polygon

var DepthLimit = 7
var Hue = 0.15

class PythagorasTree {
    construct new(width, height) {
        Window.title = "Pythagoras Tree"
        Window.resize(width, height)
        Canvas.resize(width, height)
    }

    init() {
        Canvas.cls(Color.white)
        drawTree(275, 500, 375, 500, 0)
    }

    drawTree(x1, y1, x2, y2, depth) {
        if (depth == DepthLimit) return
        var dx = x2 - x1
        var dy = y1 - y2

        var x3 = x2 - dy
        var y3 = y2 - dx
        var x4 = x1 - dy
        var y4 = y1 - dx
        var x5 = x4 + 0.5 * (dx - dy)
        var y5 = y4 - 0.5 * (dx + dy)

        // draw a square
        var col = Color.hsv((Hue + depth * 0.02) * 360, 1, 1)
        var square = Polygon.quick([[x1, y1], [x2, y2], [x3, y3], [x4, y4]])
        square.drawfill(col)
        square.draw(Color.lightgray)

        // draw a triangle
        col = Color.hsv((Hue + depth * 0.035) * 360, 1, 1)
        var triangle = Polygon.quick([[x3, y3], [x4, y4], [x5, y5]])
        triangle.drawfill(col)
        triangle.draw(Color.lightgray)

        drawTree(x4, y4, x5, y5, depth + 1)
        drawTree(x5, y5, x3, y3, depth + 1)
    }

    update() {}

    draw(alpha) {}
}

var Game = PythagorasTree.new(640, 640)
