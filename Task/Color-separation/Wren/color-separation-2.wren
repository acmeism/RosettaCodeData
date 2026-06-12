import "dome" for Window
import "graphics" for Canvas, Color, ImageData

class ColorSeparationCMY {
    construct new() {
        Window.title = "Color separation, CMY model"
        var fileName = "Lenna50.jpg"
        var image = ImageData.load(fileName)
        var w = image.width
        var h = image.height
        Window.resize(w * 4 + 40, h)
        Canvas.resize(w * 4 + 40, h)

        //draw original image
        image.draw(0, 0)

        var imgC = ImageData.create("lennaC", w, h)
        var imgM = ImageData.create("lennaM", w, h)
        var imgY = ImageData.create("lennaY", w, h)
        for (y in 0...h) {
            for (x in 0...w) {
                var col = image.pget(x, y)
                imgC.pset(x, y, Color.rgb(col.r, 255, 255))
                imgM.pset(x, y, Color.rgb(255, col.g, 255))
                imgY.pset(x, y, Color.rgb(255, 255, col.b))
            }
        }

        // draw color separated images
        imgC.draw(w + 10, 0)
        imgM.draw(2 * (w + 10), 0)
        imgY.draw(3 * (w + 10), 0)
    }

    init() {}
    update() {}
    draw(alpha) {}
}

var Game = ColorSeparationCMY.new()
