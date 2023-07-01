import "graphics" for Canvas, Color, ImageData
import "dome" for Window

class PercentageDifference {
    construct new(width, height, image1, image2) {
        Window.title = "Perecentage difference between images"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _img1 = ImageData.loadFromFile(image1)
        _img2 = ImageData.loadFromFile(image2)
        // display images side by side
        _img1.draw(0, 0)
        _img2.draw(550, 0)
        Canvas.print(image1, 200, 525, Color.white)
        Canvas.print(image2, 750, 525, Color.white)
    }

    init() {
        var dpc = (getDifferencePercent(_img1, _img2) * 1e5).round / 1e5
        System.print("Percentage difference between images: %(dpc)\%")
    }

    getDifferencePercent(img1, img2) {
        var width   = img1.width
        var height  = img1.height
        var width2  = img2.width
        var height2 = img2.height
        if (width != width2 || height != height2) {
            var f = "(%(width), %(height)) vs. (%(width2), %(height2))"
            Fiber.abort("Images must have the same dimensions: %(f)")
        }
        var diff = 0
        for (y in 0...height) {
            for (x in 0...width) {
                diff = diff + pixelDiff(img1.pget(x, y), img2.pget(x, y))
            }
        }
        var maxDiff = 3 * 255 * width * height
        return 100 * diff / maxDiff
    }

    pixelDiff(c1, c2) { (c1.r - c2.r).abs + (c1.g - c2.g).abs + (c1.b - c2.b).abs }

    update() {}

    draw(alpha) {}
}

var Game = PercentageDifference.new(1100, 550, "Lenna50.jpg", "Lenna100.jpg")
