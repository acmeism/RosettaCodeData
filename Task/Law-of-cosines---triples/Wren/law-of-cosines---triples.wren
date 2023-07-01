var squares13 = {}
var squares10000 = {}

var initMaps = Fn.new {
    for (i in 1..13) squares13[i*i] = i
    for (i in 1..10000) squares10000[i*i] = i
}

var solve = Fn.new { |angle, maxLen, allowSame|
    var solutions = []
    for (a in 1..maxLen) {
        for (b in a..maxLen) {
            var lhs = a*a + b*b
            if (angle != 90) {
                if (angle == 60) {
                    lhs = lhs - a*b
                } else if (angle == 120) {
                    lhs = lhs + a*b
                } else {
                    Fiber.abort("Angle must be 60, 90 or 120 degrees")
                }
            }
            if (maxLen == 13) {
                var c = squares13[lhs]
                if (c != null) {
                    if (allowSame || a != b || b != c) {
                        solutions.add([a, b, c])
                    }
                }
            } else if (maxLen == 10000) {
                var c = squares10000[lhs]
                if (c != null) {
                    if (allowSame || a != b || b != c) {
                        solutions.add([a, b, c])
                    }
                }
            } else {
                Fiber.abort("Maximum length must be either 13 or 10000")
            }
        }
    }
    return solutions
}

initMaps.call()
System.write("For sides in the range [1, 13] ")
System.print("where they can all be of the same length:-\n")
var angles = [90, 60, 120]
var solutions = []
for (angle in angles) {
    solutions = solve.call(angle, 13, true)
    System.write("  For an angle of %(angle) degrees")
    System.print(" there are %(solutions.count) solutions, namely:")
    System.print("  %(solutions)")
    System.print()
}
System.write("For sides in the range [1, 10000] ")
System.print("where they cannot ALL be of the same length:-\n")
solutions = solve.call(60, 10000, false)
System.write("  For an angle of 60 degrees")
System.print(" there are %(solutions.count) solutions.")
