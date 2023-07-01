import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

class GreyBars {
    construct new(width, height) {
        Window.title = "Grey bars example"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        drawBars()
    }

    drawBars() {
        var run = 0
        var colorComp = 0 // component of the color
        var columnCount = 8
        while (columnCount < 128) {
            var colorGap = 255 / (columnCount - 1) // by this gap we change the background color
            var columnWidth = (_w / columnCount).floor
            var columnHeight = (_h / 4).floor
            if (run % 2 == 0) { // switches color directions with each iteration of while loop
                colorComp = 0
            } else {
                colorComp = 255
                colorGap = -colorGap
            }
            var ystart = columnHeight * run
            var xstart = 0
            for (i in 0...columnCount) {
                var iColor = Math.round(colorComp)
                var nextColor = Color.rgb(iColor, iColor, iColor)
                Canvas.rectfill(xstart, ystart, xstart + columnWidth, ystart + columnHeight, nextColor)
                xstart = xstart + columnWidth
	            colorComp = colorComp + colorGap
	        }
            run = run + 1
            columnCount = columnCount * 2
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = GreyBars.new(640, 320)
