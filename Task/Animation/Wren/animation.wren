import "graphics" for Canvas, Color
import "dome" for Window
import "input" for Mouse

var RIGHT = true

class Animation {
    construct new() {
        Window.title = "Animation"
        _fore = Color.white
    }

    init() {
        _text = "Hello World! "
        _frame = 0
        Canvas.print(_text, 10, 10, _fore)
    }

    update() {
        _frame = _frame + 1
        if (_frame == 1200) _frame = 0
        if (!Mouse.hidden && Mouse.isButtonPressed("left")) {
            Mouse.hidden = true
            RIGHT = !RIGHT
        }
        if (_frame % 60 == 0) {
            if (RIGHT) {
                _text = _text[-1] + _text[0..-2]
            } else {
                _text = _text[1..-1] + _text[0]
            }
            Mouse.hidden = false
        }
    }

    draw(alpha) {
        Canvas.cls()
        Canvas.print(_text, 10, 10, _fore)
    }
}

var Game = Animation.new()
