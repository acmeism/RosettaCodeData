import "./fmt" for Fmt

var isSquare = Fn.new { |n|
    var s = n.sqrt.floor
    return s * s == n
}

var squares = []
for (i in 1..49) {
    if (isSquare.call(i)) {
        squares.add(i)
    } else {
        var n = i
        var limit = 10
        while (true) {
            n = n * 10
            var found = false
            for (j in 0...limit) {
                var s = n + j
                if (isSquare.call(s)) {
                    squares.add(s)
                    found = true
                    break
                }
            }
            if (found) break
            limit = limit * 10
        }
    }
}
System.print("Smallest squares that begin with 'n' in [1, 49]:")
Fmt.tprint("$5d", squares, 10)
