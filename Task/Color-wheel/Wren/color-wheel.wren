import "graphics" for Canvas, Color
import "dome" for Window
import "random" for Random

class Game {
    static init() {
        Window.title = "Color Wheel"
        __width = 640
        __height = 640
        Window.resize(__width, __height)
        Canvas.resize(__width, __height)
        colorWheel()
    }

    static colorWheel() {
        var cx = (__width/2).floor
        var cy = (__height/2).floor
        var r = (cx < cy) ? cx : cy
        for (y in 0...__height) {
            var dy = y - cy
            for (x in 0...__width) {
                var dx = x - cx
                var dist = (dx*dx + dy*dy).sqrt
                if (dist <= r) {
                    var theta = dy.atan(dx)
                    var h = (theta + Num.pi) / Num.pi * 180
                    var col = Color.hsv(h, dist/r, 1)
                    Canvas.pset(x, y, col)
                }
            }
        }
    }

    static update() {}

    static draw(alpha) {}
}
