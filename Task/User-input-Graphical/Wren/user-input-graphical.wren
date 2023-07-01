import "graphics" for Canvas, Color
import "input" for Keyboard, Clipboard
import "dome" for Window, Process

var X = 10
var Y = 28

class Main {
    construct new() {}

    init() {
        _text = ""
        _enterNum = false
        Keyboard.handleText = true
        Keyboard.textRegion(X, Y, 8, 8)
    }

    update() {
        var change = false
        if (Keyboard.text.count > 0) {
            _text = _text + Keyboard.text
            change = true
        }

        // enable backspace key to delete last character entered
        if (Keyboard["backspace"].justPressed && _text.count > 0) {
            var codePoints = _text.codePoints
            codePoints = codePoints.take(codePoints.count - 1)
            _text = ""
            for (point in codePoints) {
                _text = _text + String.fromCodePoint(point)
            }
            change = true
        }

        // enable return key to terminate input
        if (Keyboard["return"].justPressed) {
            System.print("'%(_text)' was entered.")
            if (!_enterNum) {
                _text = ""
                _enterNum = true
                change = true
            } else if (_text == "75000") {
                Process.exit()
            } else {
                _text = ""
                change = true
            }
        }

        if (change) {
            Keyboard.textRegion(X.min(_text.count * 8), Y, 8, 8)
        }
    }

    draw(dt) {
        Canvas.cls()
        Canvas.rect(X, Y, 8, 8, Color.red)
        if (!_enterNum) {
            Canvas.print("Enter Text and press return:", 10, 10, Color.white)
        } else {
            Canvas.print("Enter 75000 and press return:", 10, 10, Color.white)
        }
        Canvas.print(_text, 10, 20, Color.white)
    }
}

var Game = Main.new()
