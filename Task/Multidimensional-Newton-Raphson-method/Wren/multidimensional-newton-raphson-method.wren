import "./matrix" for Matrix
import "./fmt" for Fmt

var solve = Fn.new { |funcs, jacobian, guesses|
    var size = funcs.count
    var gu1 = []
    var gu2 = guesses.toList
    var jac = Matrix.new(size, size)
    var tol = 1e-8
    var maxIter = 12
    var iter = 0
    while (true) {
        gu1 = gu2
        var g = Matrix.new([gu1]).transpose
        var v = List.filled(size, 0)
        for (i in 0...size) v[i] = funcs[i].call(gu1)
        var f = Matrix.new([v]).transpose
        for (i in 0...size) {
            for (j in 0...size) jac[i, j] = jacobian[i][j].call(gu1)
        }
        var g1 = g - jac.inverse * f
        gu2 = List.filled(size, 0)
        for (i in 0...size) gu2[i] = g1[i][0]
        iter = iter + 1
        if (iter == maxIter) break
        if ((0...size).all { |i| (gu2[i] - gu1[i]).abs <= tol }) break
    }
    return gu2
}

/* solve the two non-linear equations:
   y = -x^2 + x + 0.5
   y + 5xy = x^2
   given initial guesses of x = y = 1.2

   Example taken from:
   http://www.fixoncloud.com/Home/LoginValidate/OneProblemComplete_Detailed.php?problemid=286

   Expected results: x = 1.23332, y = 0.2122
*/
var f1 = Fn.new { |x| -x[0] * x[0] + x[0] + 0.5 - x[1] }
var f2 = Fn.new { |x|  x[1] + 5 * x[0] * x[1] - x[0] * x[0] }
var funcs = [f1, f2]
var jacobian = [
    [ Fn.new { |x| - 2 * x[0] + 1 }, Fn.new { |x| -1 } ],
    [ Fn.new { |x| 5 * x[1] - 2 * x[0] }, Fn.new { |x| 1 + 5 * x[0] } ]
]
var guesses = [1.2, 1.2]
var sols = solve.call(funcs, jacobian, guesses)
Fmt.print("Approximate solutions are x = $.7f, y = $.7f", sols[0], sols[1])

/* solve the three non-linear equations:
   9x^2 + 36y^2 + 4z^2 - 36 = 0
   x^2 - 2y^2 - 20z = 0
   x^2 - y^2 + z^2 = 0
   given initial guesses of x = y = 1.0 and z = 0.0

   Example taken from:
   http://mathfaculty.fullerton.edu/mathews/n2003/FixPointNewtonMod.html (exercise 5)

   Expected results: x = 0.893628, y = 0.894527, z = -0.0400893
*/
System.print()
var f3 = Fn.new { |x| 9 * x[0] * x[0] + 36 * x[1] *x[1] + 4 * x[2] * x[2] - 36 }
var f4 = Fn.new { |x| x[0] * x[0] - 2 * x[1] * x[1] - 20 * x[2] }
var f5 = Fn.new { |x| x[0] * x[0] - x[1] * x[1] + x[2] * x[2] }
funcs = [f3, f4, f5]
jacobian = [
    [ Fn.new { |x| 18 * x[0] }, Fn.new { |x| 72 * x[1] }, Fn.new { |x| 8 * x[2] } ],
    [ Fn.new { |x|  2 * x[0] }, Fn.new { |x| -4 * x[1] }, Fn.new { |x| -20 } ],
    [ Fn.new { |x|  2 * x[0] }, Fn.new { |x| -2 * x[1] }, Fn.new { |x| 2 * x[2] } ]
]
guesses = [1, 1, 0]
sols = solve.call(funcs, jacobian, guesses)
Fmt.print("Approximate solutions are x = $.7f, y = $.7f, z = $.7f", sols[0], sols[1], sols[2])
