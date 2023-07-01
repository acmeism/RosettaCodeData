import "random" for Random
import "os" for Process

var Rand = Random.new()

class Direction {
    static n { __n }
    static s { __s }
    static e { __e }
    static w { __w }

    static init() {
        __n = new_(1,  0, -1)
        __s = new_(2,  0,  1)
        __e = new_(4,  1,  0)
        __w = new_(8, -1,  0)

        __n.opposite = __s
        __s.opposite = __n
        __e.opposite = __w
        __w.opposite = __e
    }

    construct new_(bit, dx, dy) {
        _bit = bit
        _dx = dx
        _dy = dy
        _opposite = null
    }

    bit { _bit }
    dx  { _dx  }
    dy  { _dy  }

    opposite     { _opposite }
    opposite=(d) { _opposite = d }
}

Direction.init()

class MazeGenerator {
    construct new(x, y) {
        _x = x
        _y = y
        _maze = List.filled(x, null)
        for (i in 0...x) _maze[i] = List.filled(y, 0)
    }

    between_(v, upper) { v >= 0 && v < upper }

    generate(cx, cy) {
        var values = [Direction.n, Direction.s, Direction.e, Direction.w]
        Rand.shuffle(values)
        values.each { |v|
            var nx = cx + v.dx
            var ny = cy + v.dy
            if (between_(nx, _x) && between_(ny, _y) && _maze[nx][ny] == 0) {
                _maze[cx][cy] = _maze[cx][cy] | v.bit
                _maze[nx][ny] = _maze[nx][ny] | v.opposite.bit
                generate(nx, ny)
            }
        }
    }

    display() {
        for (i in 0..._y) {
            // draw the north edge
            for (j in 0..._x) System.write((_maze[j][i] & 1) == 0 ? "+---" : "+   ")
            System.print("+")

            // draw the west edge
            for (j in 0..._x) System.write((_maze[j][i] & 8) == 0 ? "|   " : "    ")
            System.print("|")
        }

        // draw the bottom line
        for (j in 0..._x) System.write("+---")
        System.print("+")
    }
}

var args = Process.arguments
var x = (args.count >= 1) ? Num.fromString(args[0]) : 8
var y = (args.count == 2) ? Num.fromString(args[1]) : 8
var mg = MazeGenerator.new(x, y)
mg.generate(0, 0)
mg.display()
