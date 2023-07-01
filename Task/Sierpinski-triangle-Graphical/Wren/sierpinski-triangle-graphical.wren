import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Sierpinski Triangle"
        var size = 800
        Window.resize(size, size)
        Canvas.resize(size, size)
        Canvas.cls(Color.white)
        var level = 8
        sierpinskiTriangle(level, 20, 20, size - 40)
    }

    static update() {}

    static draw(alpha) {}

    static sierpinskiTriangle(level, x, y, size) {
        if (level > 0) {
            var col = Color.black
            Canvas.line(x, y, x + size, y, col)
            Canvas.line(x, y, x, y + size, col)
            Canvas.line(x + size, y, x, y + size, col)
            var size2 = (size/2).floor
            sierpinskiTriangle(level - 1, x, y, size2)
            sierpinskiTriangle(level - 1, x + size/2, y, size2)
            sierpinskiTriangle(level - 1, x, y + size/2, size2)
        }
    }
}
