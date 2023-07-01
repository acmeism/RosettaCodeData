import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

var Radians = Fn.new { |d| d * Num.pi / 180 }

class FractalTree {
    construct new(width, height) {
        Window.title = "Fractal Tree"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _fore = Color.white
    }

    init() {
        drawTree(400, 500, -90, 9)
    }

    drawTree(x1, y1, angle, depth) {
        if (depth == 0) return
        var r = Radians.call(angle)
        var x2 = x1 + (Math.cos(r) * depth * 10).truncate
        var y2 = y1 + (Math.sin(r) * depth * 10).truncate
        Canvas.line(x1, y1, x2, y2, _fore)
        drawTree(x2, y2, angle - 20, depth - 1)
        drawTree(x2, y2, angle + 20, depth - 1)
    }

    update() {}

    draw(alpha) {}
}

var Game = FractalTree.new(800, 600)
