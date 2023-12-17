import "./rat" for Rat
import "./fmt" for Fmt

var toContFrac = Fn.new { |r|
    var a = r.num
    var b = r.den
    while (true) {
        Fiber.yield((a/b).truncate)
        var t = a % b
        a = b
        b = t
        if (a == 1) return
    }
}

var groups = [
    [ [1, 2], [3, 1], [23, 8], [13, 11], [22, 7], [-151, 77] ],
    [ [14142, 1e4], [141421, 1e5], [1414214, 1e6], [14142136, 1e7] ],
    [ [31, 10], [314, 100], [3142, 1e3], [31428, 1e4], [314285, 1e5], [3142857, 1e6],
      [31428571, 1e7], [314285714,1e8]]
]

var lengths = [ [4, 2], [8, 8], [9, 9] ]
var headings = [ "Examples ->", "Sqrt(2) ->", "Pi ->" ]
var i = 0
for (group in groups) {
    System.print(headings[i])
    for (pair in group) {
        Fmt.write("$*d / $*d = ", lengths[i][0], pair[0], -lengths[i][1], pair[1])
        var f = Fiber.new(toContFrac)
        var r = Rat.new(pair[0], pair[1])
        while (!f.isDone) {
           var d = f.call(r)
           if (d) System.write("%(d) ")
        }
        System.print()
    }
    System.print()
    i = i + 1
}
