import "graphics" for Canvas, Color
import "dome" for Window

class FibonacciWordFractal {
    construct new(width, height, n) {
        Window.title = "Fibonacci Word Fractal"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _fore = Color.green
        _wordFractal = wordFractal(n)
    }

    init() {
        drawWordFractal(20, 20, 1, 0)
    }

    wordFractal(i) {
        if (i < 2) return (i == 1) ? "1" : ""
        var f1 = "1"
        var f2 = "0"
        for (j in i-2...0) {
            var tmp = f2
            f2 = f2 + f1
            f1 = tmp
        }
        return f2
    }

    drawWordFractal(x, y, dx, dy) {
        for (i in 0..._wordFractal.count) {
            Canvas.line(x, y, x + dx, y + dy, _fore)
            x = x + dx
            y = y + dy
            if (_wordFractal[i] == "0") {
                var tx = dx
                dx = (i % 2 == 0) ? -dy : dy
                dy = (i % 2 == 0) ?  tx : - tx
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = FibonacciWordFractal.new(450, 620, 23)
