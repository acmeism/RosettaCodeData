import "graphics" for Canvas, ImageData, Color
import "dome" for Window, Process
import "io" for FileSystem

class Bitmap {
    construct new(fileName, fileName2, width, height) {
        Window.title = "Bitmap - read PPM file"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _fn2 = fileName2
        loadPPMFile(fileName)
    }

    init() {
        toGrayScale()
        // display images side by side
        _bmp.draw(0, 0)
        _bmp2.draw(536, 0)
        // save gray scale image to file
        _bmp2.saveToFile(_fn2)
    }

    loadPPMFile(fileName) {
        var ppm = FileSystem.load(fileName)
        var count = ppm.count // ensure file is fully loaded before proceeding
        if (ppm[0..1] != "P6") {
            System.print("The loaded file is not a P6 file.")
            Process.exit()
        }
        var lines = ppm.split("\n")
        if (Num.fromString(lines[2]) > 255) {
            System.print("The maximum color value can't exceed 255.")
            Process.exit()
        }
        var wh = lines[1].split(" ")
        var w = Num.fromString(wh[0])
        var h = Num.fromString(wh[1])
        _bmp = ImageData.create(fileName, w, h)
        var bytes = ppm.bytes
        var i = bytes.count - 3 * w * h
        for (y in 0...h) {
            for (x in 0...w) {
                var r = bytes[i]
                var g = bytes[i+1]
                var b = bytes[i+2]
                var c = Color.rgb(r, g, b)
                pset(x, y, c)
                i = i + 3
            }
        }
    }

    toGrayScale() {
        _bmp2 = ImageData.create("gray scale", _bmp.width, _bmp.height)
        for (x in 0..._bmp.width) {
            for (y in 0..._bmp.height) {
                var c1 = _bmp.pget(x, y)
                var lumin = (0.2126 * c1.r + 0.7152 * c1.g + 0.0722 * c1.b).floor
                var c2 = Color.rgb(lumin, lumin,lumin, c1.a)
                _bmp2.pset(x, y, c2)
            }
        }
    }

    pset(x, y, col) { _bmp.pset(x, y, col) }

    pget(x, y) { _bmp.pget(x, y) }

    update() {}

    draw(alpha) {}
}

var Game = Bitmap.new("Lenna100.ppm", "Lenna100_gs.jpg", 1048, 512)
