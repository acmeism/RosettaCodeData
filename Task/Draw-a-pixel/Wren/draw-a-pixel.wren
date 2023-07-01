import "dome" for Window
import "graphics" for Canvas, Color

class Game {
    static init() {
        Window.title = "Draw a pixel"
        Window.resize(320, 240)
        Canvas.resize(320, 240)
        var red = Color.rgb(255, 0, 0)
        Canvas.pset(100, 100, red)
        // check it worked
        var col = Canvas.pget(100, 100)
        System.print("The color of the pixel at (100, 100) is %(getRGB(col))")
    }

    static update() {}

    static draw(dt) {}

    static getRGB(col) { "{%(col.r), %(col.g), %(col.b)}" }
}
