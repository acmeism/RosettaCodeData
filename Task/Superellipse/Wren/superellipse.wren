import "graphics" for Canvas, Color, Point

class Game {
    static init() {
        Canvas.resize(500, 500)
        // draw 200 concentric superellipses with gradually decreasing 'n'.
        for (a in 200..1) {
            superEllipse(a/80, a)
        }
    }

    static update() {}

    static draw(alpha) {}

    static superEllipse(n, a) {
        var hw = Canvas.width / 2
        var hh = Canvas.height / 2

        // calculate y for each x
        var y = List.filled(a + 1, 0)
        for (x in 0..a) {
            var aa = a.pow(n)
            var xx = x.pow(n)
            y[x] = (aa-xx).pow(1/n)
        }

        // draw quadrants
        var prev = Point.new(hw + a, hh - y[a])
        for (x in a-1..0) {
            var curr = Point.new(hw + x, hh - y[x])
            Canvas.line(prev.x, prev.y, curr.x, curr.y, Color.white)
            prev = Point.new(curr.x, curr.y)
        }

        prev = Point.new(hw, hh + y[0])
        for (x in 1..a) {
            var curr = Point.new(hw + x, hh + y[x])
            Canvas.line(prev.x, prev.y, curr.x, curr.y, Color.white)
            prev = Point.new(curr.x, curr.y)
        }

        prev = Point.new(hw - a, hh + y[a])
        for (x in a-1..0) {
            var curr = Point.new(hw - x, hh + y[x])
            Canvas.line(prev.x, prev.y, curr.x, curr.y, Color.white)
            prev = Point.new(curr.x, curr.y)
        }

        prev = Point.new(hw, hh - y[0])
        for (x in 1..a) {
            var curr = Point.new(hw - x, hh - y[x])
            Canvas.line(prev.x, prev.y, curr.x, curr.y, Color.white)
            prev = Point.new(curr.x, curr.y)
        }
    }
}
