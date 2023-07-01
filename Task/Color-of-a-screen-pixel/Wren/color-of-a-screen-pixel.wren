import "dome" for Window, Process
import "graphics" for Canvas, Color
import "input" for Mouse

class Game {
    static init() {
        Window.title = "Color of a screen pixel"
        Canvas.cls(Color.orange) // {255, 163, 0} in the default palette
    }

    static update() {
        // report location and color of pixel at mouse cursor
        // when the left button is first pressed
        if (Mouse.isButtonPressed("left")) {
            var x = Mouse.x
            var y = Mouse.y
            var col = Canvas.pget(x, y)
            System.print("The color of the pixel at (%(x), %(y)) is %(getRGB(col))")
            Process.exit(0)
        }
    }

    static draw(dt) {}

    static getRGB(col) { "{%(col.r), %(col.g), %(col.b)}" }
}
