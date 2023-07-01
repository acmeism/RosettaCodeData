import "input" for Keyboard
import "dome" for Window, Process
import "graphics" for Canvas, Color

class Game {
    static init() {
        Canvas.print("Maximize the window and press 'm'", 0, 0, Color.white)
    }

    static update() {
        if (Keyboard.isKeyDown("m") ) {
            System.print("Maximum window dimensions are %(Window.width) x %(Window.height)")
            Process.exit(0)
        }
    }

    static draw(alpha) {}
}
