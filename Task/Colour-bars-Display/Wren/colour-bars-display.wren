import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Color bars"
        __width = 400
        __height = 400
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
        drawBars(colors)
    }

    static drawBars(colors) {
        var w = __width / colors.count
        var h = __height
        for (i in 0...colors.count) {
            Canvas.rectfill(w*i, 0, w, h, colors[i])
        }
    }

    static update() {}

    static draw(dt) {}
}
