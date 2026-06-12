import "./fmt" for Fmt

class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }
    x { _x }
    y { _y }
    toString { "(%(_x), %(_y))" }
}

var debug = Fn.new { |s, x, lineNo|
    Fmt.print("$q at line $d type '$k'\nvalue: $s\n", s, lineNo, x, x)
}

var add = Fn.new { |x, y|
    var result = x + y
    debug.call("x", x, 19)
    debug.call("y", y, 20)
    debug.call("result", result, 21)
    debug.call("result+1", result+1, 22)
    return result
}

add.call(2, 7)
var b = true
debug.call("b", b, 28)
var s = "Hello"
debug.call("s", s, 30)
var p = Point.new(2, 3)
debug.call("p", p, 32)
var l = [1, "two", 3]
debug.call("l", l, 34)
