import "dome" for Window
import "graphics" for Canvas, Color, Font, ImageData

class Main {
    construct new(n) {
        var size = 60 * n + 10
        Window.resize(size, size)
        Canvas.resize(size, size)
        Window.title = "Mosaic matrix"
        // see Go-fonts page
        Font.load("Go-Regular20", "Go-Regular.ttf", 20)
        Canvas.font = "Go-Regular20"
        var beige = Color.new(245, 245, 220)
        Canvas.cls(Color.lightgray)
        for (x in 0...n) {
            for (y in 0...n) {
                var cx = x*60 + 10
                var cy = y*60 + 10
                if ((x + y) % 2 == 0) {
                    Canvas.rectfill(cx, cy, 50, 50, Color.brown)
                    Canvas.print("1", cx + 20, cy + 15, beige)
                 } else {
                    Canvas.rectfill(cx, cy, 50, 50, beige)
                 }
            }
        }
        // save to .png file for publication
        var outputImage = ImageData.create("", size, size)
        for (x in 0...size) {
            for (y in 0...size) outputImage.pset(x, y, Canvas.pget(x, y))
        }
        outputImage.saveToFile("mosaic_matrix.png")
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new(9)
