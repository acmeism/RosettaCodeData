import "dome" for Window
import "graphics" for Canvas, Color
import "random" for Random

class Game {
    static init() {
        Window.title = "Image Noise"
        __w = 320
        __h = 240
        Window.resize(__w, __h)
        Canvas.resize(__w, __h)
        __r = Random.new()
        __t = System.clock
    }

    static update() {}

    static draw(dt) {
        Canvas.cls() // default background is black
        for (x in 0...__w) {
            for (y in 0...__h) {
                if (__r.int(2) == 0) {
                    Canvas.pset(x, y, Color.white)
                }
            }
        }
        var t = System.clock
        var fps = (1/(t - __t)).round
        Canvas.print("FPS: %(fps)", 10, 10, Color.red)
        __t = t
    }
}
