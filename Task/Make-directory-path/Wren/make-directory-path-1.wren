import "io" for FileSystem

class Main {
    construct new() {}

    init() {
        FileSystem.createDirectory("path/to/dir")
    }

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
