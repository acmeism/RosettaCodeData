import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Sunflower fractal"
        var width = 400
        var height = 400
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.black)
        var col = Color.green
        var seeds = 3000
        sunflower(seeds, col)
    }

    static update() {}

    static draw(alpha) {}

    static sunflower(seeds, col) {
        var c = (5.sqrt + 1) / 2
        for (i in 0..seeds) {
            var r = i.pow(c) / seeds
            var angle = 2 * Num.pi * c * i
            var x = r*angle.sin + 200
            var y = r*angle.cos + 200
            Canvas.circle(x, y, i/seeds*5, col)
        }
    }
}
