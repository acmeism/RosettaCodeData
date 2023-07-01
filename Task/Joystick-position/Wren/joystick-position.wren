import "input" for Keyboard, GamePad
import "graphics" for Canvas, Color
import "dome" for Window

var Buttons = [
    "left", "right", "up", "down", "A", "B", "X", "Y",
    "back", "start", "guide", "leftshoulder", "rightshoulder"
]

var Symbols = ["L", "R", "U", "D", "A", "B", "X", "Y", "BK", "S", "G", "LS", "RS"]

class Main {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Joystick position"
        _w = width
        _h = height
        _dx = (width/100).floor
        _dy = (height/100).floor
        _gpd = GamePad.next
    }

    init() {
        // start in center
        _x = _w / 2
        _y = _h / 2
        Canvas.cls(Color.yellow)
        showButtonStatus()
        Canvas.print("+", _x, _y, Color.red)
    }

    update() {
        var dx = 0
        var dy = 0
        if (Keyboard.isKeyDown("left")         || _gpd.getAnalogStick("left").x < -0.25) {
            dx = -_dx
        } else if (Keyboard.isKeyDown("right") || _gpd.getAnalogStick("left").x > 0.25)  {
            dx = _dx
        } else if (Keyboard.isKeyDown("up")    || _gpd.getAnalogStick("left").y < -0.25) {
            dy =  -_dy
        } else if (Keyboard.isKeyDown("down")  || _gpd.getAnalogStick("left").y > 0.25)  {
            dy = _dy
        }
        moveCrossHair(dx, dy)
    }

    moveCrossHair(dx, dy) {
        _x = _x + dx
        _y = _y + dy
        if (_x < 0) _x = 0
        if (_x > _w - 5) _x = _w - 5
        if (_y < 0) _y = 0
        if (_y > _h * 0.96 - 5) _y = _h * 0.96 - 5
    }

    // show whether other gamepad keys are pressed by printing the corresponding symbol if they are.
    showButtonStatus() {
        Canvas.rectfill(0, _h * 0.96, _w, _h, Color.blue)
        var s = ""
        for (i in 0...Buttons.count) {
            var button = Buttons[i]
            if (_gpd.isButtonPressed(button)) s = s + "  " + Symbols[i]
        }
        Canvas.print(s, 0, _h * 0.98, Color.white)
    }

    draw(alpha) {
        Canvas.cls(Color.yellow)
        showButtonStatus()
        Canvas.print("+", _x, _y, Color.red)
    }
}

var Game = Main.new(600, 600)
