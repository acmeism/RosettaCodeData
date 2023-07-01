import "graphics" for Canvas, ImageData
import "dome" for Window
import "plugin" for Plugin

Plugin.load("pipeconv")

import "pipeconv" for PipeConv

class ConvertPPM {
    construct new(fileName, fileName2, width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Convert PPM file via pipe"
        // convert .ppm file to .jpg via a pipe
        PipeConv.convert(fileName, fileName2)
        // load and display .jpg file
        var image = ImageData.loadFromFile(fileName2)
        image.draw(0, 0)
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = ConvertPPM.new("output.ppm", "output_piped.jpg", 350, 350)
