import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Color pinstripe"
        __width = 900
        __height = 600
        Canvas.resize(__width, __height)
        Window.resize(__width, __height)
        var colors = [
            Color.hex("000000"), // black
            Color.hex("FF0000"), // red
            Color.hex("00FF00"), // green
            Color.hex("0000FF"), // blue
            Color.hex("FF00FF"), // magenta
            Color.hex("00FFFF"), // cyan
            Color.hex("FFFF00"), // yellow
            Color.hex("FFFFFF")  // white
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
                Canvas.rectfill(x, y, b, h, colors[ci%8])
                x = x + b
                ci = ci + 1
            }
        }
    }

    static update() {}

    static draw(dt) {}
}
