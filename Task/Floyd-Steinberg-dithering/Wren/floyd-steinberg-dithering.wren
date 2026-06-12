import "graphics" for Canvas, Color, ImageData
import "dome" for Window, Process

class C3 {
    static fromRGB(c) { C3.new(c.r, c.g, c.b) }

    static findClosestColor(c, palette){
        var closest = palette[0]
        for (n in palette) {
            if (n.diff(c) < closest.diff(c)) closest = n
        }
        return closest
    }

    construct new(r, g, b) {
        _r = r.round.clamp(0, 255)
        _g = g.round.clamp(0, 255)
        _b = b.round.clamp(0, 255)
    }

    r { _r }
    g { _g }
    b { _b }

    +(o) { C3.new(_r + o.r, _g + o.g, _b + o.b) }

    -(o) { C3.new(_r - o.r, _g - o.g, _b - o.b) }

    *(d) { C3.new(_r * d, _g * d, _b * d) }

    diff(o) {
        var rd = o.r - _r
        var gd = o.g - _g
        var bd = o.b - _b
        return rd * rd + gd * gd + bd * bd
    }

    toRGB() { Color.rgb(_r, _g, _b) }
}

class FloydSteinberg {
    construct new(filename) {
        var img = ImageData.load(filename)
        Window.title = filename
        var width  = img.width
        var height = img.height
        Window.resize(width, height)
        Canvas.resize(width, height)
        Canvas.cls(Color.black)
        img = dither(img, width, height)
        img.draw(0, 0) // display the dithered image
        img.saveToFile("dithered_" + filename)
    }

    dither(img, w, h) {
        var palette = [
            C3.new(  0,   0,   0),   // black
            C3.new(  0,   0, 255),   // green
            C3.new(  0, 255,   0),   // blue
            C3.new(  0, 255, 255),   // cyan
            C3.new(255,   0,   0),   // red
            C3.new(255,   0, 255),   // purple
            C3.new(255, 255,   0),   // yellow
            C3.new(255, 255, 255)    // white
        ]

        var d = List.filled(h, null)
        for (y in 0...h) {
            d[y] = List.filled(w, 0)
            for (x in 0...w) {
                var c = img.pget(x, y)
                d[y][x] = C3.fromRGB(c)
            }
        }

        for (y in 0...h) {
            for (x in 0...w) {
                var oldColor = d[y][x]
                var newColor = C3.findClosestColor(oldColor, palette)
                img.pset(x, y, newColor.toRGB())
                var err = oldColor - newColor

                if (x + 1 < w) {
                    d[y][x + 1] = d[y][x + 1] + err * (7 / 16)
                }

                if ((x - 1) >= 0 && y + 1 < h) {
                    d[y + 1][x - 1] =  d[y + 1][x - 1] + err * (3 / 16)
                }

                if (y + 1 < h) {
                    d[y + 1][x] = d[y + 1][x] + err * (5 / 16)
                }

                if (x + 1 < w && y + 1 < h) {
                    d[y + 1][x + 1] = d[y + 1][x + 1] + err * (1 / 16)
                }
            }
        }
        return img
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var args = Process.args
var Game
if (args.count < 3) {
    System.print("Please pass the name of the file to be dithered as a command line parameter.")
} else {
    var filename = args[2]
    Game = FloydSteinberg.new(filename)
}
