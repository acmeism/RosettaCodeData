// constants
var A1 = [0, 1403580, -810728]
var M1 = 2.pow(32) - 209
var A2 = [527612, 0, -1370589]
var M2 = 2.pow(32) - 22853
var D = M1 + 1

// Python style modulus
var Mod = Fn.new { |x, y|
    var m = x % y
    return (m < 0) ?  m + y.abs : m
}

class MRG32k3a {
    construct new() {
        _x1 = [0, 0, 0]
        _x2 = [0, 0, 0]
    }

    seed(seedState) {
        if (seedState <= 0 || seedState >= D) {
            Fiber.abort("Argument must be in the range [0, %(D)].")
        }
        _x1 = [seedState, 0, 0]
        _x2 = [seedState, 0, 0]
    }

    nextInt {
        var x1i = Mod.call(A1[0]*_x1[0] + A1[1]*_x1[1] + A1[2]*_x1[2], M1)
        var x2i = Mod.call(A2[0]*_x2[0] + A2[1]*_x2[1] + A2[2]*_x2[2], M2)
        _x1 = [x1i, _x1[0], _x1[1]]    /* keep last three */
        _x2 = [x2i, _x2[0], _x2[1]]    /* keep last three */
        return Mod.call(x1i - x2i, M1) + 1
    }

    nextFloat { nextInt / D }
}

var randomGen = MRG32k3a.new()
randomGen.seed(1234567)
for (i in 0..4) System.print(randomGen.nextInt)

var counts = List.filled(5, 0)
randomGen.seed(987654321)
for (i in 1..1e5) {
    var i = (randomGen.nextFloat * 5).floor
    counts[i] = counts[i] + 1
}
System.print("\nThe counts for 100,000 repetitions are:")
for (i in 0..4) System.print("  %(i) : %(counts[i])")
