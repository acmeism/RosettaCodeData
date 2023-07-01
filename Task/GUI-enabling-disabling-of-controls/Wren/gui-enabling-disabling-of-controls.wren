import "graphics" for Canvas, Color
import "input" for Mouse, Keyboard
import "dome" for Window
import "./polygon" for Polygon

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
        _enabled = true
    }

    enabled     { _enabled }
    enabled=(e) { _enabled = e }

    draw() {
        _rect.drawfill(_c)
        _rect.draw(_oc)
        var l = Canvas.getPrintArea(_legend)
        var lx = ((_w - l.x)/2).truncate
        lx = (lx > 0) ? _x + lx : _x + 1
        var ly = ((_h - l.y)/2).truncate
        ly = (ly > 0) ? _y + ly : _y + 1
        var col = _enabled ? _lc : Color.darkgray
        Canvas.print(_legend, lx, ly, col)
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
        _enabled = true
    }

    text     { _text }
    text=(t) { _text = t }

    enabled     { _enabled }
    enabled=(e) { _enabled = e }

    draw() {
        _rect.drawfill(_c)
        _rect.draw(_oc)
        var l = Canvas.getPrintArea(_label).x
        var lx = _x - l - 7
        if (lx < 1) {
             lx = 1
             _label = _label[0..._x]
        }
        var col = _enabled ? _lc : Color.darkgray
        Canvas.print(_label, lx, _y, col)
        Canvas.getPrintArea(_label).x
        Canvas.print(_text, _x + 3, _y + 1, Color.black)
    }
}

class GUIControlEnablement {
    construct new() {
        Window.title = "GUI control enablement"
        _btnIncrement = Button.new(60, 40, 80, 80, "Increment", Color.red, Color.blue, Color.white)
        _btnDecrement = Button.new(180, 40, 80, 80, "Decrement", Color.green, Color.blue, Color.white)
        _txtValue = TextBox.new(140, 160, 80, 8, "Value", Color.white, Color.blue, Color.white)
        _txtValue.text = "0"
        Keyboard.handleText = true
    }

    init() {
        _btnDecrement.enabled = false
        drawControls()
    }

    update() {
        if (_btnIncrement.enabled && _btnIncrement.justClicked) {
            var number = Num.fromString(_txtValue.text) + 1
            _btnIncrement.enabled = (number < 10)
            _btnDecrement.enabled = true
            _txtValue.enabled = (number == 0)
            _txtValue.text = number.toString
        } else if (_btnDecrement.enabled && _btnDecrement.justClicked) {
            var number = Num.fromString(_txtValue.text) - 1
            _btnDecrement.enabled = (number > 0)
            _btnIncrement.enabled = true
            _txtValue.enabled = (number == 0)
            _txtValue.text = number.toString
        } else if (_txtValue.enabled && "0123456789".any { |d| Keyboard[d].justPressed }) {
            _txtValue.text = Keyboard.text
            _txtValue.enabled = (_txtValue.text == "0")
            _btnIncrement.enabled = true
            _btnDecrement.enabled = (_txtValue.text != "0")
        }
    }

    draw(alpha) {
        drawControls()
    }

    drawControls() {
        Canvas.cls()
        _btnIncrement.draw()
        _btnDecrement.draw()
        _txtValue.draw()
    }
}

var Game = GUIControlEnablement.new()
