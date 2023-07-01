import "graphics" for Canvas, Color, ImageData
import "dome" for Window
import "plugin" for Plugin

Plugin.load("printer")

import "printer" for Printer

class Main {
    construct new() {
        Window.title = "Color pinstripe - printer"
        _width = 842
        _height = 595
        Canvas.resize(_width, _height)
        Window.resize(_width, _height)
        var colors = [
            Color.hex("000000"), // black
            Color.hex("FF0000"), // red
            Color.hex("00FF00"), // green
            Color.hex("0000FF"), // blue
            Color.hex("FF00FF"), // magenta
            Color.hex("00FFFF"), // cyan
            Color.hex("FFFF00"), // yellow
            Color.hex("FFFFFF")  // white
        ]
        pinstripe(colors)
    }

    pinstripe(colors) {
        var w = _width
        var h = (_height/7).floor
        for (b in 1..11) {
            var x = 0
            var ci = 0
            while (x < w) {
                var y = h * (b - 1)
                Canvas.rectfill(x, y, b, h, colors[ci%8])
                x = x + b
                ci = ci + 1
            }
        }
    }

    init() {
        var img = ImageData.create("color_pinstripe", _width, _height)
        for (x in 0..._width) {
            for (y in 0..._height) img.pset(x, y, Canvas.pget(x, y))
        }
        img.saveToFile("color_pinstripe.png")
        Printer.printFile("color_pinstripe.png")
    }

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
