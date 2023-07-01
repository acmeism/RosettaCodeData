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

    static bmpLine(name, x0, y0, x1, y1, col) {
        var dx = (x1 - x0).abs
        var dy = (y1 - y0).abs
        var sx = (x0 < x1) ? 1 : -1
        var sy = (y0 < y1) ? 1 : -1
        var err = ((dx > dy ? dx : - dy) / 2).floor
        while (true) {
            bmpPset(name, x0, y0, col)
            if (x0 == x1 && y0 == y1) break
            var e2 = err
            if (e2 > -dx) {
                err = err - dy
                x0 = x0 + sx
            }
            if (e2 < dy) {
                err = err + dx
                y0 = y0 + sy
            }
        }
    }

    static init() {
        Window.title = "Bresenham's line algorithm"
        var size = 200
        Window.resize(size, size)
        Canvas.resize(size, size)
        var name = "bresenham"
        var bmp = bmpCreate(name, size, size)
        bmpFill(name, Color.white)
        bmpLine(name, 50, 100, 100, 190, Color.black)
        bmpLine(name, 100, 190, 150, 100, Color.black)
        bmpLine(name, 150, 100, 100, 10, Color.black)
        bmpLine(name, 100, 10, 50, 100, Color.black)
        bmp.draw(0, 0)
    }

    static update() {}

    static draw(alpha) {}
}
