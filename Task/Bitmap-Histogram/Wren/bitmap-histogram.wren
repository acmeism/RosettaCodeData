import "dome" for Window
import "graphics" for Canvas, Color, ImageData

class ImageHistogram {
    construct new(filename, filename2) {
        _image  = ImageData.loadFromFile(filename)
        Window.resize(_image.width, _image.height)
        Canvas.resize(_image.width, _image.height)
        Window.title = filename2
        _image2 = ImageData.create("Grayscale", _image.width, _image.height)
        _image3 = ImageData.create("B & W", _image.width, _image.height)
    }

    init() {
        toGrayScale()
        var h = histogram
        var m = median(h)
        toBlackAndWhite(m)
        _image3.draw(0, 0)
        _image3.saveToFile(Window.title)
    }

    luminance(c) { (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b).floor }

    toGrayScale() {
        for (x in 0..._image.width) {
            for (y in 0..._image.height) {
                var c1 = _image.pget(x, y)
                var lumin = luminance(c1)
                var c2 = Color.rgb(lumin, lumin, lumin, c1.a)
                _image2.pset(x, y, c2)
            }
        }
    }

    toBlackAndWhite(median) {
        for (x in 0..._image2.width) {
            for (y in 0..._image2.height) {
                var c = _image2.pget(x, y)
                var lum = luminance(c)
                if (lum < median) {
                    _image3.pset(x, y, Color.black)
                } else {
                    _image3.pset(x, y, Color.white)
                }
            }
        }
    }

    histogram {
        var h = List.filled(256, 0)
        for (x in 0..._image2.width) {
            for (y in 0..._image2.height) {
                var c = _image2.pget(x, y)
                var lum = luminance(c)
                h[lum] = h[lum] + 1
             }
        }
        return h
    }

    median(h) {
        var lSum  = 0
        var rSum  = 0
        var left  = 0
        var right = 255
        while (true) {
            if (lSum < rSum) {
                lSum = lSum + h[left]
                left = left + 1
            } else {
                rSum = rSum + h[right]
                right = right - 1
            }
            if (left == right) break
        }
        return left
    }

    update() {}

    draw(alpha) {}
}

var Game = ImageHistogram.new("Lenna100.jpg", "Lenna100_B&W.png")
