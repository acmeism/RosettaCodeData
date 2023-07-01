import "audio" for AudioEngine

class Main {
    construct new() {}

    init() {
        AudioEngine.load("morse", "morse_code.wav")
        AudioEngine.play("morse")
    }

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
