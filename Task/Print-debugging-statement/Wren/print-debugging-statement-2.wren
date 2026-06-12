import "./fmt" for Fmt
import "./debug" for Debug

class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }
    x { _x }
    y { _y }
    toString { "(%(_x), %(_y))" }
}

var add = Fn.new { |x, y|
    var result = x + y
    Debug.print("x|y|result|result+1", 16, x, y, result, result + 1)
    return result
}

add.call(2, 7)
var b = true
var s = "Hello"
var p = Point.new(2, 3)
var l = [1, "two", 3]
Debug.nl
Debug.print("b|s|p|l", 25, b, s, p, l)
