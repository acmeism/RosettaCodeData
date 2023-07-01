import "graphics" for Canvas, Color, Point
import "dome" for Window

class Game {
    static init() {
        Window.title = "Hilbert curve"
        Canvas.resize(650, 650)
        Window.resize(650, 650)
        __points = []
        __width = 64
        hilbert(0, 0, __width, 0, 0)
        var col = Color.hex("#90EE90") // light green
        var prev = __points[0]
        for (p in __points.skip(1)) {
            var curr = p
            Canvas.line(prev.x, prev.y, curr.x, curr.y, col)
            prev = curr
        }
    }

    static hilbert(x, y, lg, i1, i2) {
        if (lg == 1) {
            var px = (__width - x) * 10
            var py = (__width - y) * 10
            __points.add(Point.new(px, py))
            return
        }
        lg = lg >> 1
        hilbert(x+i1*lg, y+i1*lg, lg, i1, 1-i2)
        hilbert(x+i2*lg, y+(1-i2)*lg, lg, i1, i2)
        hilbert(x+(1-i1)*lg, y+(1-i1)*lg, lg, i1, i2)
        hilbert(x+(1-i2)*lg, y+i2*lg, lg, 1-i1, i2)
    }

    static update() {}

    static draw(dt) {}
}
