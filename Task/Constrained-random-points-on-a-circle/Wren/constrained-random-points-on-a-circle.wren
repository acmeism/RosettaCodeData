import "graphics" for Canvas, Color
import "dome" for Window
import "random" for Random

class Game {
    static init() {
        Window.title = "Constrained random points on a circle"
        var width = 800
        var height = 800
        Window.resize(width, height)
        Canvas.resize(width, height)
        var rand = Random.new()
        var count = 0
        var max = 100 // set to 1000 to produce a much more pronounced annulus
        while (true) {
            var x = rand.int(-15, 16)
            var y = rand.int(-15, 16)
            var dist = (x*x + y*y).sqrt
            if (10 <= dist && dist <= 15) {
                // translate coordinates to fit in the window
                Canvas.circlefill((x + 16) * 25, (y + 16) * 25, 2, Color.white)
                count = count + 1
                if (count == max) break
            }
        }
    }

    static update() {}

    static draw(alpha) {}
}
