import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Pinstripe"
        __width = 900
        __height = 600
        Canvas.resize(__width, __height)
        Window.resize(__width, __height)
        var colors = [
            Color.hex("FFFFFF"), // white
            Color.hex("000000")  // black
        ]
        pinstripe(colors)
    }

    static pinstripe(colors) {
        var w = __width
        var h = (__height/4).floor
        for (b in 1..4) {
            var x = 0
            var ci = 0
            while (x < w) {
                var y = h * (b - 1)
                Canvas.rectfill(x, y, b, h, colors[ci%2])
                x = x + b
                ci = ci + 1
            }
        }
    }

    static update() {}

    static draw(dt) {}
}
