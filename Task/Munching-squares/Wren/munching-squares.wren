import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Munching squares"
        var w = 512
        var h = 512
        Window.resize(w, h)
        Canvas.resize(w, h)
        for (x in 0...w) {
            for (y in 0...h) {
                var c = (x ^ y) & 255
                Canvas.pset(x, y, Color.rgb(255-c, (c/2).floor, c))
            }
        }
    }

    static update() {}

    static draw(alpha) {}
}
