import "/fmt" for Fmt

class Sandpile {
    // 'a' is a list of integers in row order
    construct new(a) {
        var count = a.count
        _rows = count.sqrt.floor
        if (_rows * _rows != count) Fiber.abort("The matrix of values must be square.")
        _a = a
        _neighbors = List.filled(count, 0)
        for (i in 0...count) {
            _neighbors[i] = []
            if (i % _rows > 0)     _neighbors[i].add(i-1)
            if ((i + 1)%_rows > 0) _neighbors[i].add(i+1)
            if (i - _rows >= 0)    _neighbors[i].add(i-_rows)
            if (i + _rows < count) _neighbors[i].add(i+_rows)
        }
    }

    isStable { _a.all { |i| i <= 3 } }

    // topples until stable
    topple() {
        while (!isStable) {
            for (i in 0..._a.count) {
                if (_a[i] > 3) {
                    _a[i] = _a[i] - 4
                    for (j in _neighbors[i]) _a[j] = _a[j] + 1
                }
            }
        }
    }

    toString {
        var s = ""
        for (i in 0..._rows) {
            for (j in 0..._rows) s = s + Fmt.swrite("$2d ", _a[_rows*i + j])
            s = s + "\n"
        }
        return s
    }
}

var printAcross = Fn.new { |str1, str2|
    var r1 = str1.split("\n")
    var r2 = str2.split("\n")
    var rows = r1.count - 1
    var cr = (rows/2).floor
    for (i in 0...rows) {
        var symbol = (i == cr) ? "->" : "  "
        Fmt.print("$s $s $s", r1[i], symbol, r2[i])
    }
    System.print()
}

var a1 = List.filled(25, 0)
a1[12] = 4
var a2 = List.filled(25, 0)
a2[12] = 6
var a3 = List.filled(25, 0)
a3[12] = 16
var a4 = List.filled(100, 0)
a4[55] = 64
for (a in [a1, a2, a3, a4]) {
    var s = Sandpile.new(a)
    var str1 = s.toString
    s.topple()
    var str2 = s.toString
    printAcross.call(str1, str2)
}
