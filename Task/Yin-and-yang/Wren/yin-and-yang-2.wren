import "dome" for Window
import "graphics" for Canvas, Color

class YinAndYang {
    construct new(width, height) {
        Window.title = "Yin and Yang"
        Window.resize(width, height)
        Canvas.resize(width, height)
    }

    init() {
        Canvas.cls(Color.yellow)
        yinAndYang(200, 220, 220)
        yinAndYang(100, 460, 460)
    }

    inCircle(centerX, centerY, radius, x, y) {
        return (x-centerX)*(x-centerX)+(y-centerY)*(y-centerY) <= radius*radius
    }

    inBigCircle(radius, x, y)        { inCircle(0, 0, radius, x, y) }

    inBlackSemiCircle(radius, x, y)  { inCircle(0,  radius/2, radius/2, x, y) }

    inWhiteSemiCircle(radius, x, y)  { inCircle(0, -radius/2, radius/2, x, y) }

    inSmallBlackCircle(radius, x, y) { inCircle(0, -radius/2, radius/6, x, y) }

    inSmallWhiteCircle(radius, x, y) { inCircle(0,  radius/2, radius/6, x, y) }

    yinAndYang(radius, ox, oy) {
        Canvas.offset(ox, oy)
        var scaleX = 2
        var scaleY = 1
        for (sy in radius*scaleY..-(radius*scaleY)) {
            for (sx in -(radius*scaleX)..(radius*scaleX)) {
                var x = sx / scaleX
                var y = sy / scaleY
                if (inBigCircle(radius, x, y)) {
                    if (inWhiteSemiCircle(radius, x, y)) {
                        var c = inSmallBlackCircle(radius, x, y) ? Color.black : Color.white
                        Canvas.pset(x, y, c)
                    } else if (inBlackSemiCircle(radius, x, y)) {
                        var c = inSmallWhiteCircle(radius, x, y) ? Color.white : Color.black
                        Canvas.pset(x, y, c)
                    } else {
                        var c = (x < 0) ? Color.white : Color.black
                        Canvas.pset(x, y, c)
                    }
                }
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = YinAndYang.new(600, 600)
