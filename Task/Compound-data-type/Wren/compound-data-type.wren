class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }
    x { _x }
    y { _y }

    // for illustration allow Points to be mutated
    x=(value) { _x = value }
    y=(value) { _y = value }

    toString { "(%(_x), %(_y))" }
}

var p = Point.new(1, 2)
System.print(p.toString)

// mutate Point object
p.x = 2
p.y = 3
// print without using the toString method
System.printAll(["(", p.x, ", ", p.y, ")"])
