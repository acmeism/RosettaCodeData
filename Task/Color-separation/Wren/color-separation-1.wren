import "dome" for Window
import "graphics" for Canvas, Color, ImageData

class ColorSeparationRGB {
    construct new() {
        Window.title = "Color separation, RGB model"
        var fileName = "Lenna50.jpg"
        var image = ImageData.load(fileName)
        var w = image.width
        var h = image.height
        Window.resize(w * 4 + 40, h)
        Canvas.resize(w * 4 + 40, h)

        //draw original image
        image.draw(0, 0)

        var imgR = ImageData.create("lennaR", w, h)
        var imgG = ImageData.create("lennaG", w, h)
        var imgB = ImageData.create("lennaB", w, h)
        for (y in 0...h) {
            for (x in 0...w) {
                var col = image.pget(x, y)
                imgR.pset(x, y, Color.rgb(col.r, 0, 0))
                imgG.pset(x, y, Color.rgb(0, col.g, 0))
                imgB.pset(x, y, Color.rgb(0, 0, col.b))
            }
        }

        // draw color separated images
        imgR.draw(w + 10, 0)
        imgG.draw(2 * (w + 10), 0)
        imgB.draw(3 * (w + 10), 0)
    }

    init() {}
    update() {}
    draw(alpha) {}
}

var Game = ColorSeparationRGB.new()
