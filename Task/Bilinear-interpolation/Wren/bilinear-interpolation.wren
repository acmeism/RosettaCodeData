import "dome" for Window
import "graphics" for Canvas, Color, ImageData
import "math" for Math

/* gets the 'n'th byte of a 4-byte integer */
var GetByte = Fn.new { |i, n| (i >> (n * 8)) & 0xff }

var Blerp = Fn.new { |c00, c10, c01, c11, tx, ty|
    return Math.lerp(Math.lerp(c00, tx, c10), ty, Math.lerp(c01, tx, c11))
}

var ColorToInt = Fn.new { |c| (c.r) + (c.g << 8) + (c.b << 16) + (c.a << 24) }

class BilinearInterpolation {
    construct new(filename, filename2, scaleX, scaleY) {
        Window.title = "Bilinear interpolation"
        _img = ImageData.load(filename)
        var newWidth  = (_img.width * scaleX).floor
        var newHeight = (_img.height * scaleY).floor
        Window.resize(newWidth, newHeight)
        Canvas.resize(newWidth, newHeight)
        _img2 = ImageData.create(filename2, newWidth, newHeight)
        _filename2 = filename2
    }

    init() {
        scaleImage()
    }

    scaleImage() {
        for (x in 0..._img2.width) {
            for (y in 0..._img2.height) {
                var gx = x / _img2.width * (_img.width - 1)
                var gy = y / _img2.height * (_img.height - 1)
                var gxi = gx.floor
                var gyi = gy.floor
                var rgb = 0
                var c00 = _img.pget(gxi, gyi)
                var c10 = _img.pget(gxi+1, gyi)
                var c01 = _img.pget(gxi, gyi+1)
                var c11 = _img.pget(gxi+1, gyi+1)
                for (i in 0..3) {
                    var b00 = GetByte.call(ColorToInt.call(c00), i)
                    var b10 = GetByte.call(ColorToInt.call(c10), i)
                    var b01 = GetByte.call(ColorToInt.call(c01), i)
                    var b11 = GetByte.call(ColorToInt.call(c11), i)
                    var ble = Blerp.call(b00, b10, b01, b11, gx-gxi, gy-gyi).floor << (8 * i)
                    rgb = rgb | ble
                }
                var r = GetByte.call(rgb, 0)
                var g = GetByte.call(rgb, 1)
                var b = GetByte.call(rgb, 2)
                var a = GetByte.call(rgb, 3)
                _img2.pset(x, y, Color.rgb(r, g, b, a))
            }
        }
        _img2.draw(0, 0)
        _img2.saveToFile(_filename2)
    }

    update() {}

    draw(alpha) {}
}

var Game = BilinearInterpolation.new("Lenna100.jpg", "Lenna100_larger.png", 1.6, 1.6)
