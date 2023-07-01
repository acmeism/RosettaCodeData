import "graphics" for Canvas, ImageData, Color, Point
import "dome" for Window

class Game {
    static bmpCreate(name, w, h) { ImageData.create(name, w, h) }

    static bmpFill(name, col) {
        var image = ImageData[name]
        for (x in 0...image.width) {
            for (y in 0...image.height) image.pset(x, y, col)
        }
    }

    static bmpPset(name, x, y, col) { ImageData[name].pset(x, y, col) }

    static bmpPget(name, x, y) { ImageData[name].pget(x, y) }

    static bmpLine(name, x0, y0, x1, y1, col) {
        var dx = (x1 - x0).abs
        var dy = (y1 - y0).abs
        var sx = (x0 < x1) ? 1 : -1
        var sy = (y0 < y1) ? 1 : -1
        var err = ((dx > dy ? dx : - dy) / 2).floor
        while (true) {
            bmpPset(name, x0, y0, col)
            if (x0 == x1 && y0 == y1) break
            var e2 = err
            if (e2 > -dx) {
                err = err - dy
                x0 = x0 + sx
            }
            if (e2 < dy) {
                err = err + dx
                y0 = y0 + sy
            }
        }
    }

    static bmpQuadraticBezier(name, p1, p2, p3, col, n) {
        var pts = List.filled(n+1, null)
        for (i in 0..n) {
            var t = i / n
            var u = 1 - t
            var a = u * u
            var b = 2 * t * u
            var c = t * t
            var px = (a * p1.x + b * p2.x + c * p3.x).truncate
            var py = (a * p1.y + b * p2.y + c * p3.y).truncate
            pts[i] = Point.new(px, py, col)
        }
        for (i in 0...n) {
            var j = i + 1
            bmpLine(name, pts[i].x, pts[i].y, pts[j].x, pts[j].y, col)
        }
    }

    static init() {
        Window.title = "Quadratic Bézier curve"
        var size = 320
        Window.resize(size, size)
        Canvas.resize(size, size)
        var name = "quadratic"
        var bmp = bmpCreate(name, size, size)
        bmpFill(name, Color.white)
        var p1 = Point.new( 10, 100)
        var p2 = Point.new(250, 270)
        var p3 = Point.new(150,  20)
        bmpQuadraticBezier(name, p1, p2, p3, Color.darkpurple, 20)
        bmp.draw(0, 0)
    }

    static update() {}

    static draw(alpha) {}
}
