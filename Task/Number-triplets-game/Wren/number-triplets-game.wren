import "dome" for Window
import "graphics" for Canvas, Color, Font
import "audio" for AudioEngine
import "input" for Mouse
import "random" for Random
import "./ellipse" for Button

var Rand = Random.new()

class NumberTriplets {
    construct new() {
        Window.resize(900, 600)
        Canvas.resize(900, 600)
        Window.title = "Number triplets game"
        // see Go-fonts page
        Font.load("Go-Regular30", "Go-Regular.ttf", 30)
        Canvas.font = "Go-Regular30"
        // download from https://soundbible.com/509-Mouse-Double-Click.html
        AudioEngine.load("click", "mouse_click.wav")
    }

    init() {
        newGame()
    }

    newGame() {
        Canvas.cls(Color.darkgray)
        _btnMap = List.filled(5, null)
        for (r in 0..4) _btnMap[r] = List.filled(9, null)
        for (c in 0..8) _btnMap[0][c] = [Color.blue, 0]
        for (r in 1..4) {
            for (c in [0, 8]) _btnMap[r][c] = [Color.black, 0]
            for (c in [1, 3, 5, 7]) {
                _btnMap[r][c] = (r == 1) ? [Color.yellow, 0] : [Color.red, 0]
            }
            for (c in [2, 4, 6]) _btnMap[r][c] = [Color.white, 0]
        }
        _sel = [-2, -2] // denotes no button selected
        _btns = List.filled(5, null)
        for (r in 0..4) {
            _btns[r] = List.filled(9, null)
            for (c in 0..8) {
                _btns[r][c] = Button.square(c * 100 + 50, r * 100 + 50, 80)
                _btns[r][c].drawfill(_btnMap[r][c][0])
            }
        }
        _btnNew = Button.new(450, 550, 860, 80)
        _btnNew.drawfill(Color.black)
        Canvas.print("New Game", 370, 530, Color.purple)
        // randomize labels on red buttons
        for (r in 2..4) {
            var labels = Rand.shuffle([1, 2, 3, 4])
            var i = 0
            for (c in [1, 3, 5, 7]) {
                var b = _btns[r][c]
                var lbl = _btnMap[r][c][1] = labels[i]
                Canvas.print(lbl.toString, b.cx - 10, b.cy - 20, Color.white)
                i = i + 1
            }
        }
    }

    update() {
        if (Mouse["left"].justPressed) {
            AudioEngine.play("click")
            var x = Mouse.x
            var y = Mouse.y
            var r = (y / 100).floor
            if (r == 5) {
                if (_btnNew.contains(x, y)) newGame()
                return
            }
            var m = y % 100
            if (m < 10 || m > 90) return
            var c = (x / 100).floor
            var n = x % 100
            if (n < 10 || n > 90) return
            var b = _btnMap[r][c]
            if (b[0] == Color.black || b[0] == Color.white) return
            if (b[0] == Color.red) {
               if (_sel[0] != -2) _btns[_sel[0]][_sel[1]].draw(Color.red)
               _sel = [r, c]
               _btns[r][c].draw(Color.white)
            } else if (b[0] == Color.yellow) {
                if (_sel[0] == r - 1 || _sel[0] == r + 1) {
                    var btn = _btns[r][c]
                    btn.drawfill(Color.red)
                    var lbl = _btnMap[_sel[0]][c][1]
                    _btnMap[r][c] = [Color.red, lbl]
                    Canvas.print(lbl.toString, btn.cx - 10, btn.cy - 20, Color.white)
                    if (_sel[0] == 0) {
                        _btns[0][c].drawfill(Color.blue)
                        _btnMap[0][c] = [Color.blue, 0]
                    } else {
                        _btns[_sel[0]][c].drawfill(Color.yellow)
                        _btnMap[_sel[0]][c] = [Color.yellow, 0]
                    }
                    _sel = [-2, -2]
                }
            } else if (b[0] == Color.blue) {
                if (_sel[0] == r + 1 || _sel[1] == c - 1 || _sel[1] == c + 1) {
                    var btn = _btns[r][c]
                    btn.drawfill(Color.red)
                    var lbl = _btnMap[_sel[0]][_sel[1]][1]
                    _btnMap[r][c] = [Color.red, lbl]
                    Canvas.print(lbl.toString, btn.cx - 10, btn.cy - 20, Color.white)
                    if (_sel[0] == 0) {
                        _btns[0][_sel[1]].drawfill(Color.blue)
                        _btnMap[0][_sel[1]] = [Color.blue, 0]
                    } else if (_sel[0] > 0) {
                        _btns[_sel[0]][_sel[1]].drawfill(Color.yellow)
                        _btnMap[_sel[0]][_sel[1]] = [Color.yellow, 0]
                    }
                    _sel = [-2, -2]
                }
            }
        }
    }

    draw(alpha) {}
}

var Game = NumberTriplets.new()
