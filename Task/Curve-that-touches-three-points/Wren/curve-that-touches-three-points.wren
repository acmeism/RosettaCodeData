import "graphics" for Canvas, Color, Point
import "dome" for Window

class Game {
    static init() {
        Window.title = "Quadratic curve"
        var width = 210
        var height = 210
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.white)
        var n = 50
        var p = [Point.new(10, 10), Point.new(100, 200), Point.new(200, 10)]
        var col = Color.black // black curve
        quadratic(n, p, col)
    }

    static update() {}

    static draw(alpha) {}

    static lagrange(p, x) {
        return (x-p[1].x)*(x-p[2].x)/(p[0].x-p[1].x)/(p[0].x-p[2].x)*p[0].y +
        (x-p[0].x)*(x-p[2].x)/(p[1].x-p[0].x)/(p[1].x-p[2].x)*p[1].y +
        (x-p[0].x)*(x-p[1].x)/(p[2].x-p[0].x)/(p[2].x-p[1].x)*p[2].y
    }

    static quadratic(n, p, col) {
        var pts = List.filled(2*n+1, null)
        var dx = (p[1].x - p[0].x) / n
        for (i in 0...n) {
            var x = p[0].x + dx*i
            pts[i] = Point.new(x, lagrange(p, x))
        }
        dx = (p[2].x - p[1].x) / n
        for (i in n...2*n+1) {
            var x = p[1].x + dx*(i-n)
            pts[i] = Point.new(x, lagrange(p, x))
        }
        var prev = pts[0]
        for (pt in pts.skip(1)) {
            Canvas.line(prev.x, prev.y, pt.x, pt.y, col)
            prev = pt
        }
    }
}
