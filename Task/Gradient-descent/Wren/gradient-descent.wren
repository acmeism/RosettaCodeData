import "./fmt" for Fmt

// Function for which minimum is to be found.
var g = Fn.new { |x|
    return (x[0]-1)*(x[0]-1)*
        (-x[1]*x[1]).exp + x[1]*(x[1]+2)*
        (-2*x[0]*x[0]).exp
}

// Provides a rough calculation of gradient g(p).
var gradG = Fn.new { |p|
    var x = p[0]
    var y = p[1]
    return [2*(x-1)*(-y*y).exp - 4*x*(-2*x*x).exp*y*(y+2),
            -2*(x-1)*(x-1)*y*(-y*y).exp + (-2*x*x).exp*(y+2) + (-2*x*x).exp*y]
}

var steepestDescent = Fn.new { |x, alpha, tolerance|
    var n = x.count
    var g0 = g.call(x) // // Initial estimate of result.

    // Calculate initial gradient.
    var fi = gradG.call(x)

    // Calculate initial norm.
    var delG = 0
    for (i in 0...n) delG = delG + fi[i]*fi[i]
    delG = delG.sqrt
    var b = alpha/delG

    // Iterate until value is <= tolerance.
    while (delG > tolerance) {
        // Calculate next value.
        for (i in 0...n) x[i] = x[i] - b*fi[i]

        // Calculate next gradient.
        fi = gradG.call(x)

        // Calculate next norm.
        delG = 0
        for (i in 0...n) delG = delG + fi[i]*fi[i]
        delG = delG.sqrt
        b = alpha/delG

        // Calculate next value.
        var g1 = g.call(x)

        // Adjust parameter.
        if (g1 > g0) {
            alpha = alpha / 2
        } else {
            g0 = g1
        }
    }
}

var tolerance = 0.0000006
var alpha = 0.1
var x = [0.1, -1] // Initial guess of location of minimum.

steepestDescent.call(x, alpha, tolerance)
System.print("Testing steepest descent method:")
Fmt.print("The minimum is at x = $f, y = $f for which f(x, y) = $f.", x[0], x[1], g.call(x))
