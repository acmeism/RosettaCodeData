import "graphics" for Canvas, Color, Point
import "dome" for Window

class Game {
    static init() {
        Window.title = "Pentagram"
        var width = 640
        var height = 640
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.white)
        var col = Color.hex("#6495ed") // cornflower blue
        for (i in 1..240) pentagram(320, 320, i, col)
        for (i in 241..250) pentagram(320, 320, i, Color.black)
    }

    static update() {}

    static draw(alpha) {}

    static pentagram(x, y, r, col) {
        var points = List.filled(5, null)
        for (i in 0..4) {
            var angle = 2*Num.pi*i/5 - Num.pi/2
            points[i] = Point.new(x + r*angle.cos, y + r*angle.sin)
        }
        var prev = points[0]
        for (i in 1..5) {
            var index = (i * 2) % 5
            var curr = points[index]
            Canvas.line(prev.x, prev.y, curr.x, curr.y, col)
            prev = curr
        }
    }
}
