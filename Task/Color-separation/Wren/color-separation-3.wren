import "dome" for Window
import "graphics" for Canvas, Color, ImageData
import "math" for Math

class ColorSeparationCMYK {
    construct new() {
        Window.title = "Color separation, CMYK model"
        var fileName = "lady.png"
        var image = ImageData.load(fileName)
        var w = image.width
        var h = image.height
        Window.resize(w * 4 + 40, h * 2 + 20)
        Canvas.resize(w * 4 + 40, h * 2 + 20)

        // draw original image on top row
        image.draw(0, 0)

        var imgC = ImageData.create("ladyC", w, h)
        var imgM = ImageData.create("ladyM", w, h)
        var imgY = ImageData.create("ladyY", w, h)
        var imgK = ImageData.create("ladyK", w, h)
        for (j in 0...h) {
            for (i in 0...w) {
                var col = image.pget(i, j)
                var rc = 255 - col.r
                var gc = 255 - col.g
                var bc = 255 - col.b
                var k = Math.min(Math.min(rc, gc), bc)
                var kc = 255 - k
                if (kc != 0) {
                    var c = (((rc - k) / kc) * 255).floor
                    var m = (((gc - k) / kc) * 255).floor
                    var y = (((bc - k) / kc) * 255).floor
                    imgC.pset(i, j, Color.rgb(255-c, 255, 255))
                    imgM.pset(i, j, Color.rgb(255, 255-m, 255))
                    imgY.pset(i, j, Color.rgb(255, 255, 255-y))
                } else {
                    imgC.pset(i, j, Color.rgb(255, 255, 255))
                    imgM.pset(i, j, Color.rgb(255, 255, 255))
                    imgY.pset(i, j, Color.rgb(255, 255, 255))
                }
                imgK.pset(i, j, Color.rgb(kc, kc, kc))
            }
        }

        // draw color separated images on bottom row
        imgC.draw(0, h + 10)
        imgM.draw(w + 10, h + 10)
        imgY.draw(2 * (w + 10), h + 10)
        imgK.draw(3 * (w + 10), h + 10)
    }

    init() {}
    update() {}
    draw(alpha) {}
}

var Game = ColorSeparationCMYK.new()
