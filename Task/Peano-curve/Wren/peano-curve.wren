import "graphics" for Canvas, Color, Point
import "dome" for Window

class Game {
    static init() {
        Window.title = "Peano curve"
        Canvas.resize(820, 820)
        Window.resize(820, 820)
        Canvas.cls(Color.white) // white background
        __points = []
        __width = 81
        peano(0, 0, __width, 0, 0)
        var col = Color.rgb(255, 0, 255) // magenta
        var prev = __points[0]
        for (p in __points.skip(1)) {
            var curr = p
            Canvas.line(prev.x, prev.y, curr.x, curr.y, col)
            prev = curr
        }
    }

    static peano(x, y, lg, i1, i2) {
        if (lg == 1) {
            var px = (__width - x) * 10
            var py = (__width - y) * 10
            __points.add(Point.new(px, py))
            return
        }
        lg = (lg/3).floor
        peano(x+2*i1*lg, y+2*i1*lg, lg, i1, i2)
        peano(x+(i1-i2+1)*lg, y+(i1+i2)*lg, lg, i1, 1-i2)
        peano(x+lg, y+lg, lg, i1, 1-i2)
        peano(x+(i1+i2)*lg, y+(i1-i2+1)*lg, lg, 1-i1, 1-i2)
        peano(x+2*i2*lg, y+2*(1-i2)*lg, lg, i1, i2)
        peano(x+(1+i2-i1)*lg, y+(2-i1-i2)*lg, lg, i1, i2)
        peano(x+2*(1-i1)*lg, y+2*(1-i1)*lg, lg, i1, i2)
        peano(x+(2-i1-i2)*lg, y+(1+i2-i1)*lg, lg, 1-i1, i2)
        peano(x+2*(1-i2)*lg, y+2*i2*lg, lg, 1-i1, i2)
    }

    static update() {}

    static draw(dt) {}
}
