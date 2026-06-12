import "graphics" for Canvas, Color
import "dome" for Window

class Game {
    static init() {
        Window.title = "Diamond"
        Window.resize(600, 600)
        Canvas.resize(600, 600)
        Canvas.cls(Color.white)
        drawDiamond()
    }

    static drawDiamond() {
        var clr = Color.rgb(0, 120, 255, 255)
        var thk = 3

        var cx = 300  // center
        var y1 = 150  // top edge
        var y2 = 230  // wide part
        var y3 = 450  // bottom tip

        // Symmetrical drawing around the cx axis.
        Canvas.line(cx - 80, y1, cx + 80, y1, clr, thk)   // top
        Canvas.line(cx + 80, y1, cx + 160, y2, clr, thk)  // upper right
        Canvas.line(cx + 160, y2, cx, y3, clr, thk)       // lower right
        Canvas.line(cx, y3, cx - 160, y2, clr, thk)       // lower left
        Canvas.line(cx - 160, y2, cx - 80, y1, clr, thk)  // upper left

        // Inner edges (facets) aligned to the center line.
        Canvas.line(cx - 160, y2, cx + 160, y2, clr, thk) // girdle line
        Canvas.line(cx - 80, y1, cx, y3, clr, thk)        // inner left diagonal
        Canvas.line(cx + 80, y1, cx, y3, clr, thk)        // inner right diagonal
    }

    static update() {}

    static draw(alpha) {}
}
