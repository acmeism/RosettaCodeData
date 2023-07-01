import "graphics" for Canvas, ImageData, Color
import "dome" for Window

class Game {
    static bmpCreate(name, w, h) { ImageData.create(name, w, h) }

    static bmpFill(name, col) {
        var image = ImageData[name]
        for (x in 0...image.width) {
            for (y in 0...image.height) image.pset(x, y, col)
        }
    }

    static bmpPset(name, x, y, col) { ImageData[name].pset(x, y, col) }

    static bmpPget(name, x, y) { ImageData[name].pget(x, y) }

    static init() {
        Window.title = "Bitmap"
        var size = 600
        Window.resize(size, size)
        Canvas.resize(size, size)
        var bmp = bmpCreate("rcbmp", size/2, size/2)
        bmpFill("rcbmp", Color.yellow)
        bmpPset("rcbmp", size/4, size/4, Color.blue) // 'blue' is #29ADFF on the default palette
        var col = bmpPget("rcbmp", size/4, size/4)
        System.print(col.toString) // check it's blue - alpha component (FF) will also be shown
        bmp.draw(150, 150)
    }

    static update() {}

    static draw(alpha) {}
}
