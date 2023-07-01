import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Archimedean Spiral"
        __width = 400
        __height = 400
        Canvas.resize(__width, __height)
        Window.resize(__width, __height)
        var col = Color.red
        spiral(col)
    }

    static spiral(col) {
        var theta = 0
        while (theta < 52 * Num.pi) {
            var x = ((theta/Num.pi).cos * theta + __width/2).truncate
            var y = ((theta/Num.pi).sin * theta + __height/2).truncate
            Canvas.pset(x, y, col)
            theta = theta + 0.025
        }
    }

    static update() {}

    static draw(dt) {}
}
