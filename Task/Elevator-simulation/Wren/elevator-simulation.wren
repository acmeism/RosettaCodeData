import "dome" for Window, Platform, Process
import "graphics" for Canvas, Color, Font
import "audio" for AudioEngine
import "input" for Mouse
import "random" for Random
import "./dynamic" for Enum
import "./ellipse" for Circle, Polygon, Rectangle, Square

var Direction = Enum.create("Direction", ["halted", "up", "down"])

var Rand = Random.new()

class Elevator {
    construct new() {
        Window.resize(820, 820)
        Canvas.resize(820, 820)
        Window.title = "Elevator game"
        // see Go-fonts page
        Font.load("Go-Regular20", "Go-Regular.ttf", 20)
        Canvas.font = "Go-Regular20"
        Font.load("Go-Regular25", "Go-Regular.ttf", 25)
        // download from https://soundbible.com/509-Mouse-Double-Click.html
        AudioEngine.load("click", "mouse_click.wav")
    }

    init() {
        newGame()
    }

    newGame() {
        _buttons = []

        // floors
        for (i in 1..7) {
            Canvas.rectfill(120, 100*i + 5, 90, 90, Color.white)
        }

        // floor up/down buttons
        Canvas.rectfill(300, 30, 100, 200, Color.orange)
        var up = Square.new(315, 45, 70, "up")
        up.drawfill(Color.lightgray)
        _buttons.add(up)
        Canvas.print("\u25b2", 345, 70, Color.black)
        var down = Square.new(315, 145, 70, "down")
        down.drawfill(Color.lightgray)
        _buttons.add(down)
        Canvas.print("\u25bc", 345, 170, Color.black)

        // floor number buttons
        Canvas.rectfill(250, 305, 200, 490, Color.orange)
        var f25 = "Go-Regular25"

        var floor5 = Circle.new(300, 350, 40, 5)
        floor5.drawfill(Color.lightgray)
        Canvas.print("5", 295, 340, Color.black, f25)

        var floor6 = Circle.new(400, 350, 40, 6)
        floor6.drawfill(Color.lightgray)
        Canvas.print("6", 395, 340, Color.black, f25)

        var floor3 = Circle.new(300, 450, 40, 3)
        floor3.drawfill(Color.lightgray)
        Canvas.print("3", 295, 440, Color.black, f25)

        var floor4 = Circle.new(400, 450, 40, 4)
        floor4.drawfill(Color.lightgray)
        Canvas.print("4", 395, 440, Color.black, f25)

        var floor1 = Circle.new(300, 550, 40, 1)
        floor1.drawfill(Color.lightgray)
        Canvas.print("1", 295, 540, Color.black, f25)

        var floor2 = Circle.new(400, 550, 40, 2)
        floor2.drawfill(Color.lightgray)
        Canvas.print("2", 395, 540, Color.black, f25)

        var ground = Square.fromCenter(350, 650, 80, "ground")
        ground.drawfill(Color.white)
        Canvas.print("GF", 335, 640, Color.black, f25)

        var close = Square.fromCenter(350, 750, 80, "close")
        close.drawfill(Color.white, Color.black, 2)
        Canvas.print("\u25ba\u25c4", 330, 740, Color.black)

        _buttons.addAll([floor1, floor2, floor3, floor4, floor5, floor6, ground, close])

        // new game button
        var newGame = Rectangle.new(525, 355, 150, 50, "new")
        newGame.drawfill(Color.orange)
        Canvas.print("New Game", 545, 365, Color.black)
        _buttons.add(newGame)

        // exit button
        var exit = Rectangle.new(525, 595, 150, 50, "exit")
        exit.drawfill(Color.orange)
        Canvas.print("Exit", 575, 605, Color.black)
        _buttons.add(exit)

        _floor = Rand.int(0, 7) // start by placing lift on a random floor
        drawLift()
        openDoors()
        changeFloorNumber()
        _dir = Direction.halted
        _floorDest = _floor
        _start = 0

        _wait = Rand.int(0, 7)  // start with a random wait point, different to where lift is
        if (_wait == _floor) {
            _wait = _floor - 1
            if (_wait < 0) _wait = 2
        }
        var wait = Polygon.regular(4, 165, 750 - _wait*100, 45, 0)
        wait.drawfill(Color.yellow, Color.black)
        Canvas.print("WAIT", 140, 740 - _wait*100, Color.black)
    }

    update() {
        if (Mouse["left"].justPressed) {
            var x = Mouse.x
            var y = Mouse.y
            for (btn in _buttons) {
                if (btn.contains(x, y)) {
                    var t = btn.tag
                    if (t == "up") {
                        if (_floor < 6) {
                            _dir = Direction.up
                            _floorDest = 6
                        }
                    } else if (t == "down") {
                        if (_floor > 0) {
                            _dir = Direction.down
                            _floorDest = 0
                        }
                    } else if (t is Num) {
                         if (t < _floor) {
                            _dir = Direction.down
                         } else if (t > _floor) {
                            _dir = Direction.up
                         } else {
                            _dir = Direction.halted
                            openDoors()
                         }
                         _floorDest = t
                    } else if (t == "ground") {
                         if (_floor > 0) {
                            _dir = Direction.down
                         } else {
                            _dir = Direction.halted
                            openDoors()
                         }
                         _floorDest = 0
                    } else if (t == "close") {
                         if (_dir == Direction.halted) {
                            closeDoors()
                         }
                    } else if (t == "new") {
                        Canvas.cls("black")
                        newGame()
                    } else if (t == "exit") {
                        Process.exit()
                    }
                    if (_dir != Direction.halted) {
                        closeDoors()
                        _start = Platform.time
                    } else {
                        _start = 0
                    }
                }
            }
        }
    }

    drawLift() {
        Canvas.rectfill(120, 100*(7 - _floor) + 5, 90, 90, Color.blue)
    }

    undrawLift() {
        Canvas.rectfill(120, 100*(7 - _floor) + 5, 90, 90, Color.white)
    }

    changeFloorNumber() {
        Canvas.rectfill(120, 30, 90, 40, Color.orange)
        Canvas.print(_floor.toString, 160, 40, Color.black)
    }

    openDoors() {
        Canvas.rectfill(135, 100*(7 - _floor) + 30, 60, 60, Color.white)
    }

    closeDoors() {
        Canvas.rectfill(120, 100*(7 - _floor) + 5, 90, 90, Color.blue)
    }

    draw(alpha) {
        if (_start > 0) {
            var delta = Platform.time - _start
            if (delta >= 1) {
                undrawLift()
                _floor = (_dir == Direction.up) ? _floor + 1 : _floor - 1
                drawLift()
                changeFloorNumber()
                if (_floor == _wait) {
                    _dir = Direction.halted
                    _start = 0
                    _wait = -1
                    openDoors()
                } else if (_floor == _floorDest) {
                    _dir = Direction.halted
                    _start = 0
                    openDoors()
                } else {
                    _start = _start + delta
                }
            }
        }
    }
}

var Game = Elevator.new()
