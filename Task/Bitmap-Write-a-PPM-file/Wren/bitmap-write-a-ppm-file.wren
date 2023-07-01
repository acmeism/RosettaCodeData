import "graphics" for Canvas, ImageData, Color
import "dome" for Window, Process
import "io" for FileSystem

class Bitmap {
    construct new(name, width, height) {
        Window.title = name
        Window.resize(width, height)
        Canvas.resize(width, height)
        _bmp = ImageData.create(name, width, height)
        // create bitmap
        for (y in 0...height) {
            for (x in 0...width) {
                var c = Color.rgb(x % 256, y % 256, (x * y) % 256)
                pset(x, y, c)
            }
        }
        _w = width
        _h = height
    }

    init() {
        // write bitmap to a PPM file
        var ppm = "P6\n%(_w) %(_h)\n255\n"
        for (y in 0..._h) {
            for (x in 0..._w) {
                var c = pget(x, y)
                ppm = ppm + String.fromByte(c.r)
                ppm = ppm + String.fromByte(c.g)
                ppm = ppm + String.fromByte(c.b)
            }
        }
        FileSystem.save("output.ppm", ppm)
        Process.exit(0)
    }

    pset(x, y, col) { _bmp.pset(x, y, col) }

    pget(x, y) { _bmp.pget(x, y) }

    update() {}

    draw(alpha) {}
}

var Game = Bitmap.new("Bitmap - write to PPM  file", 320, 320)
