import "graphics" for Canvas, Color, Point
import "dome" for Window
import "math" for M

class Game {
    static init() {
        Window.title = "Koch curve"
        Canvas.resize(512, 512)
        Window.resize(512, 512)
        Canvas.cls(Color.white) // white background
        koch(100, 100, 400, 400, 4)
        koch(101, 100, 401, 400, 4) // 2 pixels wide
    }

    static koch(x1, y1, x2, y2, iter) {
        var angle = Num.pi / 3 // 60 degrees
        var x3 = (x1*2 + x2) / 3
        var y3 = (y1*2 + y2) / 3
        var x4 = (x1 + x2*2) / 3
        var y4 = (y1 + y2*2) / 3
        var x5 = x3 + (x4-x3)*M.cos(angle) + (y4-y3)*M.sin(angle)
        var y5 = y3 - (x4-x3)*M.sin(angle) + (y4-y3)*M.cos(angle)
        if (iter > 0) {
            iter = iter - 1
            koch(x1, y1, x3, y3, iter)
            koch(x3, y3, x5, y5, iter)
            koch(x5, y5, x4, y4, iter)
            koch(x4, y4, x2, y2, iter)
        } else {
            Canvas.line(x1, y1, x3, y3, Color.blue)
            Canvas.line(x3, y3, x5, y5, Color.blue)
            Canvas.line(x5, y5, x4, y4, Color.blue)
            Canvas.line(x4, y4, x2, y2, Color.blue)
        }
    }

    static update() {}

    static draw(dt) {}
}
