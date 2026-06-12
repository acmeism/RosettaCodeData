import "dome" for Window
import "input" for Keyboard
import "graphics" for Canvas, Color
import "./matrix" for Matrix
import "./polygon" for Square

var walshMatrix = Fn.new { |n|
    var walsh = Matrix.new(n, n, 0)
    walsh[0, 0] = 1
    var k = 1
    while (k < n) {
        for (i in 0...k) {
            for (j in 0...k) {
                walsh[i+k, j]   =  walsh[i, j]
                walsh[i, j+k]   =  walsh[i, j]
                walsh[i+k, j+k] = -walsh[i, j]
            }
        }
        k = k + k
    }
    return walsh
}

var signChanges = Fn.new { |row|
    var n = row.count
    var sc = 0
    for (i in 1...n) {
        if (row[i-1] == -row[i]) sc = sc + 1
    }
    return sc
}

var WalshNaturalCache = {}
var WalshSequencyCache = {}

for (order in [2, 4, 5]) {
    var n = 1 << order
    var w = walshMatrix.call(n).toList
    WalshNaturalCache[order] = w
}

for (order in [2, 4, 5]) {
    var rows = WalshNaturalCache[order].toList
    rows.sort { |r1, r2| signChanges.call(r1) < signChanges.call(r2) }
    WalshSequencyCache[order] = rows
}

class WalshMatrix {
    construct new() {
        Window.title = "Walsh Matrix"
        Window.resize(1020, 750)
        Canvas.resize(1020, 750)
        var bc = Color.black
        for (natural in [true, false]) {
            if (natural) {
                Canvas.print("NATURAL ORDERING", 450, 10, Color.blue)
            } else {
                Canvas.print("SEQUENCY ORDERING", 450, 400, Color.blue)
            }
            var z = 10
            for (order in [2, 4, 5]) {
                var y = natural ? 30 : 420
                var mat = natural ? WalshNaturalCache[order] : WalshSequencyCache[order]
                var n = 1 << order
                var size = 320 / n
                for (row in mat) {
                    var x = z
                    for (i in row) {
                        var fc = (i == 1) ? Color.green : Color.red
                        var sq = Square.new(x, y, size)
                        sq.drawfill(fc, bc)
                        x = x + size
                    }
                    y = y + size
                }
                z = z + 340
            }
        }
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = WalshMatrix.new()
