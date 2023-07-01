var powers = Fn.new { |m|
    var i = 0
    return Fn.new {
        var p = i.pow(m)
        i = i + 1
        return p
    }
}

var squaresNotCubes = Fn.new { |squares, cubes|
    var sq = squares.call()
    var cu = cubes.call()
    return Fn.new {
        var p
        while (true) {
            if (sq < cu) {
                p = sq
                sq = squares.call()
                return p
            }
            if (sq == cu) sq = squares.call()
            cu = cubes.call()
        }
    }
}

var squares = powers.call(2)
var cubes = powers.call(3)
var sqNotCu = squaresNotCubes.call(squares, cubes)
for (i in 0..29) {
    var p = sqNotCu.call()
    if (i > 19) System.write("%(p) ")
}
System.print()
