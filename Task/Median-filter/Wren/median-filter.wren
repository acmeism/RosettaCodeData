import "graphics" for Canvas, ImageData, Color
import "dome" for Window

class MedianFilter {
    construct new(filename, filename2, windowWidth, windowHeight) {
        Window.title = "Median filter"
        var image = ImageData.loadFromFile(filename)
        Window.resize(image.width, image.height)
        Canvas.resize(image.width, image.height)
        _ww = windowWidth
        _wh = windowHeight
        // split off the left half
        _image = ImageData.create(filename2, image.width/2, image.height)
        _name = filename2
        for (x in 0...image.width/2) {
            for (y in 0...image.height) _image.pset(x, y, image.pget(x, y))
        }
        // display it on the left before filtering
        _image.draw(0, 0)
    }

    luminance(c) { 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b }

    medianFilter(windowWidth, windowHeight) {
        var window = List.filled(windowWidth * windowHeight, Color.black)
        var edgeX = (windowWidth / 2).floor
        var edgeY = (windowHeight / 2).floor
        var comparer = Fn.new { |a, b| luminance(a) < luminance(b) }
        for (x in edgeX..._image.width - edgeX) {
            for (y in edgeY..._image.height - edgeY) {
                var i = 0
                for (fx in 0...windowWidth) {
                    for (fy in 0...windowHeight) {
                        window[i] = _image.pget(x + fx - edgeX, y + fy - edgeY)
                        i = i + 1
                    }
                }
                window.sort(comparer)
                _image.pset(x, y, window[((windowWidth * windowHeight)/2).floor])
            }
        }
    }

    init() {
        medianFilter(_ww, _wh)
        // display it on the right after filtering
        _image.draw(_image.width, 0)
        // save it to a file
        _image.saveToFile(_name)
    }

    update() {}

    draw(alpha) {}
}

var Game = MedianFilter.new("Medianfilterp.png", "Medianfilterp2.png", 3, 3)
