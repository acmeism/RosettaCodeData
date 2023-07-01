import "graphics" for Canvas, Color
import "input" for Mouse, Keyboard
import "dome" for Window
import "random" for Random
import "./polygon" for Polygon

var Rand = Random.new()

class Button {
    construct new(x, y, w, h, legend, c, oc, lc) {
        var vertices = [[x, y], [x+w, y], [x+w, y+h], [x, y+h]]
        _rect = Polygon.quick(vertices)
        _x = x
        _y = y
        _w = w
        _h = h
        _legend = legend
        _c = c
        _oc = oc
        _lc = lc
    }

    draw() {
        _rect.drawfill(_c)
        _rect.draw(_oc)
        var l = Canvas.getPrintArea(_legend)
        var lx = ((_w - l.x)/2).truncate
        lx = (lx > 0) ? _x + lx : _x + 1
        var ly = ((_h - l.y)/2).truncate
        ly = (ly > 0) ? _y + ly : _y + 1
        Canvas.print(_legend, lx, ly, _lc)
    }

    justClicked { Mouse["left"].justPressed && _rect.contains(Mouse.position.x, Mouse.position.y) }
}

class TextBox {
    construct new(x, y, w, h, label, c, oc, lc) {
        var vertices = [[x, y], [x+w, y], [x+w, y+h], [x, y+h]]
        _rect = Polygon.quick(vertices)
        _x = x
        _y = y
        _w = w
        _h = h
        _label = label
        _c = c
        _oc = oc
        _lc = lc
        _text = ""
    }

    text     { _text }
    text=(t) { _text = t }

    draw() {
        _rect.drawfill(_c)
        _rect.draw(_oc)
        var l = Canvas.getPrintArea(_label).x
        var lx = _x - l - 7
        if (lx < 1) {
             lx = 1
             _label = _label[0..._x]
        }
        Canvas.print(_label, lx, _y, _lc)
        Canvas.getPrintArea(_label).x
        Canvas.print(_text, _x + 3, _y + 1, Color.black)
    }
}

class GUIComponentInteraction {
    construct new() {
        Window.title = "GUI component interaction"
        _btnIncrement = Button.new(60, 40, 80, 80, "Increment", Color.red, Color.blue, Color.white)
        _btnRandom = Button.new(180, 40, 80, 80, "Random", Color.green, Color.blue, Color.white)
        _txtValue = TextBox.new(140, 160, 80, 8, "Value", Color.white, Color.blue, Color.white)
        _txtValue.text = "0"
        Keyboard.handleText = true
        _waiting = false
    }

    init() {
        drawControls()
    }

    update() {
        if (_waiting) {
            if (Keyboard["Y"].justPressed) {
                var rn = Rand.int(1000)  // max 999 say
                _txtValue.text = rn.toString
                _waiting = false
            } else if (Keyboard["N"].justPressed) {
                _waiting = false
            }
        } else if (_btnIncrement.justClicked) {
            var number = Num.fromString(_txtValue.text) + 1
            _txtValue.text = number.toString
        } else if (_btnRandom.justClicked) {
            Canvas.print("Reset to a random number y/n?", 60, 200, Color.white)
            _waiting = true
        } else if ("0123456789".any { |d| Keyboard[d].justPressed }) {
            if (_txtValue.text != "0") {
                _txtValue.text = _txtValue.text + Keyboard.text
            } else {
                _txtValue.text = Keyboard.text
            }
        }
    }

    draw(alpha) {
        if (!_waiting) drawControls()
    }

    drawControls() {
        Canvas.cls()
        _btnIncrement.draw()
        _btnRandom.draw()
        _txtValue.draw()
    }
}

var Game = GUIComponentInteraction.new()
