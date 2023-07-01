import "dome" for Window

class EmptyWindow {
    construct new(width, height) {
        Window.title = "Empty window"
        Window.resize(width, height)
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = EmptyWindow.new(600, 600)
