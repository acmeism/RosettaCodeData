import "audio" for AudioEngine

class Main {
    construct new() {}

    init() {
        AudioEngine.load("doremi", "musical_scale.wav")
        AudioEngine.play("doremi")
    }

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
