import "graphics" for Canvas, Color
import "input" for Mouse
import "dome" for Window

class SimpleWindowedApplication {
    construct new(width, height) {
        Window.title = "Simple windowed application"
        _fore = Color.white
        _clicks = 0
    }

    init() {
        drawControls()
    }

    update() {
        if (Mouse["left"].justPressed && insideButton) _clicks = _clicks + 1
    }

    draw(alpha) {
        drawControls()
    }

    insideButton {
        var p = Mouse.position
        return p.x >= 120 && p.x <= 200 && p.y >= 90 && p.y <= 170
    }

    drawControls() {
        Canvas.cls()
        if (_clicks == 0) {
            Canvas.print("There have been no clicks yet", 40, 40, _fore)
        } else if (_clicks == 1) {
            Canvas.print("The button has been clicked once", 30, 40, _fore)
        } else {
            Canvas.print("The button has been clicked %(_clicks) times", 10, 40, _fore)
        }
        Canvas.rectfill(120, 90, 80, 80, Color.red)
        Canvas.rect(120, 90, 80, 80, Color.blue)
        Canvas.print("click me", 130, 125, _fore)
    }
}

var Game = SimpleWindowedApplication.new(600, 600)
