import "graphics" for Canvas, Color, ImageData
import "dome" for Window

class PercentageDifference {
    construct new(width, height, image1, image2) {
        Window.title = "Grayscale Image"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _image1 = image1
        _image2 = image2
        _img1 = ImageData.loadFromFile(image1)
        _img2 = ImageData.create(image2, _img1.width, _img1.height)
    }

    init() {
        toGrayScale()
        // display images side by side
        _img1.draw(0, 0)
        _img2.draw(550, 0)
        Canvas.print(_image1, 200, 525, Color.white)
        Canvas.print(_image2, 750, 525, Color.white)
    }

    toGrayScale() {
        for (x in 0..._img1.width) {
            for (y in 0..._img1.height) {
                var c1 = _img1.pget(x, y)
                var lumin = (0.2126 * c1.r + 0.7152 * c1.g + 0.0722 * c1.b).floor
                var c2 = Color.rgb(lumin, lumin,lumin, c1.a)
                _img2.pset(x, y, c2)
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = PercentageDifference.new(1100, 550, "Lenna100.jpg", "Lenna-grayscale.jpg")
