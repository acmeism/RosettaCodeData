import "./fmt" for Fmt

// Prints a row of the Romberg table.
var printRow = Fn.new { |i, R|
    Fmt.write("R[$d] = ", i)
    for (j in 0..i) Fmt.write("$0.8f ", R[j])
    System.print()
}

/* Calculates the integral of a function using Romberg integration.

    Args:
        f: The function to integrate.
        a: Lower limit of integration.
        b: Upper limit of integration.
        maxSteps: Maximum number of steps.
        acc: Desired accuracy.

    Returns:
        The approximate value of the integral.
*/
var romberg = Fn.new { |f, a, b, maxSteps, acc|
    // Buffers for storing previous and current rows.
    var Rp = List.filled(maxSteps, 0)
    var Rc = List.filled(maxSteps, 0)

    var h = b - a  // step size
    Rp[0] = (f.call(a) + f.call(b)) * h * 0.5  // first trapezoidal step
    printRow.call(0, Rp)

    for (i in 1...maxSteps) {
        h = h / 2
        var c = 0
        var ep = 1 << (i - 1)
        for (j in 1..ep) {
            c = c + f.call(a + (2 * j - 1) * h)
        }
        Rc[0] = h * c + 0.5 * Rp[0]

        for (j in 1..i) {
            var nk = 4.pow(j)
            Rc[j] = (nk * Rc[j - 1] - Rp[j - 1]) / (nk - 1)
        }

        // Print i'th row of R, R[i][i] is the best estimate so far.
        printRow.call(i, Rc)

        if (i > 1 && (Rp[i - 1] - Rc[i]).abs < acc) return Rc[i]

        // Swap Rp, Rc as we only need the last row.
        var rt = Rp
        Rp = Rc
        Rc = rt
    }
    return Rp[-1] // return our best guess
}

Fmt.print("Integration of sin(x) over [0, 1] with a maximum of 5 steps.")
Fmt.print("$0.8f", romberg.call(Fn.new { |x| x.sin },  0, 1, 5, 1e-8))
System.print()

Fmt.print("Integration of exp(x) over [-3, 3] with a maximum of 5 steps.")
Fmt.print("$0.8f", romberg.call(Fn.new { |x| x.exp }, -3, 3, 5, 1e-8))
