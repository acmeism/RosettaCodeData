import "./math" for Math
import "./complex" for Complex
import "./fmt" for Fmt

/* Code to find roots of a polynomial. Only works if there are no more than 2 complex roots. */

// Basic polynomial class - only need division.
// Assumes coeffs are ordered from the constant term up to the term with the highest degree.
class Polynom {
    construct new(coeffs) {
        _coeffs = coeffs.toList
    }

    coeffs { _coeffs.toList }

    /(divisor) {
        var curr = canonical().coeffs
        var right = divisor.canonical().coeffs
        var result = []
        var base = curr.count - right.count
        while (base >= 0) {
            var res = curr[-1] / right[-1]
            result.add(res)
            curr = curr[0...-1]
            for (i in 0...right.count-1) {
                curr[base + i] = curr[base + i] - res * right[i]
            }
            base = base - 1
        }
        var quot = Polynom.new(result[-1..0])
        var rem = Polynom.new(curr).canonical()
        return [quot, rem]
    }

    canonical() {
        if (_coeffs[-1] != 0) return this
        var newLen = coeffs.count
        while (newLen > 0) {
            if (_coeffs[newLen-1] != 0) return Polynom.new(_coeffs[0...newLen])
            newLen = newLen - 1
        }
        return Polynom.new(_coeffs[0..0])
    }
}

// Assumes real coefficients, highest to lowest order.
var quadratic = Fn.new { |a, b, c|
    var d = b*b - 4*a*c
    if (d == 0) {
        // single real root
        var root = -b/(a*2)
        return [root, root]
    }
    if (d > 0) {
        // two real roots
        var sr = d.sqrt
        d = (b < 0) ? sr - b : -sr - b
        return [d/(2*a), 2*c/d]
    }
    // two complex roots
    var den = 1 / (2*a)
    var t1 = Complex.new(-b*den, 0)
    var t2 = Complex.new(0, (-d).sqrt * den)
    return [t1+t2, t1-t2]
}

// Finds the roots of a polynomial.
// Assumes coeffs are ordered from the highest to lowest degree.
// i.e. in the opposite direction to the Polynom class above.
var polyRoots = Fn.new { |coeffs|
    if (coeffs.count < 2) return []
    if (coeffs.count == 2) return [-coeffs[1]]
    var roots = []
    var coeffs2 = coeffs.toList
    while (true) {
        if (coeffs2.count == 3) {
            var qroots = quadratic.call(coeffs2[0], coeffs2[1], coeffs2[2])
            roots.addAll(qroots)
            break
        }
        var root = Math.rootPoly(coeffs2)
        if (!root) break
        roots.add(root)
        var poly = Polynom.new(coeffs2[-1..0])
        var rootPoly = Polynom.new([-root, 1])
        var quot = (poly / rootPoly)[0]
        coeffs2 = quot.coeffs[-1..0]
    }
    return roots
}

/* Main code for task. */

// Performs the three necessary conditions (sufficient for n <= 2).
var myTest3 = Fn.new { |pCoeffs, nOrder|
    var stability = true

    // 1. P(z=1) > 0
    var valAt1 = Math.evalPoly(pCoeffs, 1)
    var test1 = (valAt1 > 1e-9)  // numerically robust check for > 0
    var ft = test1 ? "TRUE" : "FALSE"
    Fmt.print("\t       P(z = 1)  > 0    =>  $9.3g  > 0         => $s", valAt1, ft)
    if (!test1) stability = false

    // 2. (-1)^n * P(z=-1) > 0
    var valAtMinus1 = Math.evalPoly(pCoeffs, -1)
    var termWithN = ((-1).pow(nOrder)) * valAtMinus1
    var test2 = (termWithN > 1e-9)  // numerically robust check for > 0
    ft = test2 ? "TRUE" : "FALSE"
    Fmt.print("\t (-1)$S P(z = -1) > 0    =>  $9.3g  > 0         => $s", nOrder, termWithN, ft)
    if (!test2) stability = false

    // 3. |an| > |a0|
    var an = pCoeffs[0]
    var a0 = pCoeffs[-1]  // a0 is the last coefficient
    var test3 = (an.abs > a0.abs)
    ft = test3 ? "TRUE" : "FALSE"
    Fmt.print("\t            |an| > |a0| =>   |$7.3g| > |$7.3g| => $s", an, a0, ft)
    if (!test3) stability = false
    return stability
}

// Constructs the Jury table.
var juryTable = Fn.new { |pCoeffs, nOrder|
    var numCoeffs = nOrder + 1
    var T = List.filled(2 * nOrder - 3, null)
    // First two rows.
    T[0] = pCoeffs[-1..0]  // pCoeffs reversed [a0, a1, ..., an]
    T[1] = pCoeffs.toList  // [an, an-1, ..., a0]
    // Third row - first derived row
    T[2] = List.filled(numCoeffs, 0)
    for (i in 0...numCoeffs) T[2][i] = T[0][0] * T[0][i] - T[1][0] * T[1][i]

    if (nOrder > 3) {
        // Set remaining rows to zero initially.
        for (i in 3...T.count) T[i] = List.filled(numCoeffs, 0)
        for (j in 2...nOrder - 1) {
            var idxPrevMainRow =  2 * j - 2
            var idxNewEvenRow  =  2 * j - 1
            var idxNewMainRow  =  2 * j
            var sliceLenForFlip = nOrder  // numCoeffs - 1

            var sourceForFlip = T[idxPrevMainRow][0...sliceLenForFlip]
            var flipped = sourceForFlip[-1..0]
            for (k in 0...sliceLenForFlip) T[idxNewEvenRow][k] = flipped[k]

            for (l in 0...numCoeffs) {
                T[idxNewMainRow][l] = T[idxPrevMainRow][0] * T[idxPrevMainRow][l] -
                                      T[idxNewEvenRow][0]  * T[idxNewEvenRow][l]
            }
        }
    }
    return T
}

var printJuryTable = Fn.new { |T, nOrder|
    var numTotalCols = nOrder + 1  // max mumber of coefficients displayed intitially
    System.print("  Row\t\t Table\n")

    // Loop for main table body (pairs of rows).
    for (i in 0...nOrder - 2) {
        var row1Idx = i * 2
        var row2Idx = i * 2 + 1

        // Number of elements to print in this pair of rows (decreases)
        var numElementsToPrint = numTotalCols - i

        System.write("  %(nOrder - i)\t| ")  // row "order" label
        for (j in 0...numElementsToPrint) Fmt.write("\t$6.3g", T[row1Idx][j])
        System.print("\n")

        System.write("\t| ")
        for (j in 0...numElementsToPrint) Fmt.write("\t$6.3g", T[row2Idx][j])
        System.print("\n")

        System.write("\t-------")
        for (j in 0...numElementsToPrint) Fmt.write("\t-------")
        System.print("---\n")
    }

    // Print the last "main" row relevant for testing (order 2 polynomial coeffs).
    var lastMainRowIdx = (nOrder - 2) * 2

    System.write("  2\t| ")  // Label for this row is '2' (for order 2 poly)
    for (j in 0..2) {  // print first 3 elements: c2, c1, c0
        if (j < T[0].count) {  // check bounds, T should have at least 3 cols
            Fmt.write("\t$6.3g", T[lastMainRowIdx][j])
        }
    }
    System.print("\t\n\n\n")
}

// Performs additional n - 2 tests using the Jury table
var addTest = Fn.new { |T, nOrder|
    var stability = true

    for (i in 1...nOrder - 1) {
        var riga = 2 * i
        var idxLastCoeff = nOrder - i

        var valFirst = T[riga][0]
        var valLast  = T[riga][idxLastCoeff]

        var currentTest = (valFirst.abs > valLast.abs)
        var ft = currentTest ? "TRUE" : "FALSE"
        Fmt.print("\t| $9.3g | > | $9.3g | \t\t => $s", valFirst, valLast, ft)
        if (!currentTest) stability = false
    }
    return stability
}

// Prints roots of the polynomial.
var printRoots = Fn.new { |pCoeffs|
    if (pCoeffs.count == 0 || pCoeffs[0] == 0) {
        System.print("\t Polynomial is zero or empty, roots are undefined or infinite.")
        return
    }
    if (pCoeffs.count == 1) {
        System.print("\t Polynomial is a non-zero constant, no roots.")
        return
    }
    // Check if leading coefficient is zero, which means polynomial order is effectively lower.
    var actualCoeffs = pCoeffs.toList
    while (actualCoeffs[0] == 0) actualCoeffs.removeAt(0)
    if (actualCoeffs.isEmpty) {  // all zeros
        System.print("\t Polynomial is all zeros, roots are undefined.")
        return
    }
    if (actualCoeffs.count == 1) {  // reduced to a constant
        System.print("\t Polynomial reduced to a non-zero constant, no roots.")
        return
    }
    var calculatedRoots = polyRoots.call(actualCoeffs)
    var i = 0
    for (root in calculatedRoots) {
        var modulus = root.abs
        if ((root is Complex) && root.imag.abs < 1e-9) { // treat as real
            root = root.real
        }
        if (root is Complex) {
            Fmt.print("\t z$d = $7.3z => modulus = $7.3g", i + 1, root, modulus)
        } else {
            Fmt.print("\t z$d = $7.3g \t\t => modulus = $7.3g", i + 1, root, modulus)
        }
        i = i + 1
    }
}

// Main Jury criterion function.
var juryC = Fn.new { |pIn|
    // Input argument validation.
    if (!(pIn is List && pIn.count > 0 && (pIn[0] is Num))) {
        System.print("\n\nInput error. P must be a single dimensional non-empty list.")
        System.print("\tjuryC.call([an, an-1, ..., a1, a0])")
        return null
    }

    // Remove leading zeros, as Jury criterion assumes 'an' != 0.
    var pCoeffs = pIn.toList
    while (pCoeffs[0] == 0) pCoeffs.removeAt(0)
    if (pCoeffs.count == 0) {  // all zeros originally
        System.print("\n\nInput error: Polynomial is all zeros.")
        return null
    }
    if (pCoeffs.count < 2) {  // constant polynomial [a0] or reduced to it
        System.print("\n\nInput error or trivial case: Polynomial order is < 1 (P=%(pCoeffs)).")
        System.print("Jury criterion is for order >= 1.")
        return null
    }

    System.print("\n*****************************************")
    System.write("\nPolynomial under test: ")

    if (pCoeffs[0] < 0) {
        for (i in 0...pCoeffs.count) pCoeffs[i] = -pCoeffs[i]  // ensure 'an' > 0
    }
    Fmt.pprint("$j", pCoeffs, "", "z")
    var nOrder = pCoeffs.count - 1

    var T = null
    var stabilityFlag = false

    if (nOrder <= 2) {
        System.print("\nPolynomial order = %(nOrder) THEN\n")
        System.print("Necessary and sufficient conditions:\n")
        stabilityFlag = myTest3.call(pCoeffs, nOrder)
        if (stabilityFlag) {
            System.print("\nThe system is stable. The roots are:")
        } else {
             System.print("\n*** The system IS NOT STABLE ***. \n\nThe roots are:\n")
        }
    } else {  // nOrder > 2
        System.print("\nPolynomial order = %(nOrder)\n")
        System.print("Necessary conditions:\n")
        stabilityFlag = myTest3.call(pCoeffs, nOrder)

        if (stabilityFlag) {
            System.print("\nThe necessary conditions are met. \n")
            System.print("It is necessary to build the Jury table.\n")

            T = juryTable.call(pCoeffs, nOrder)
            printJuryTable.call(T, nOrder)

            System.print("Additional condition to test = %(nOrder - 2) \n")
            stabilityFlag = addTest.call(T, nOrder)

            if (stabilityFlag) {
                System.print("\nThe system is stable. The roots are:\n")
            } else {
                System.print("\n*** The system IS NOT STABLE ***. \n\nThe roots are:\n")
            }
        } else {
            System.print("\n*** The system IS NOT STABLE because the necessary conditions are not met***. \n\nThe roots are:\n")
        }
    }
    printRoots.call(pCoeffs)  // print roots of the polynomial

    return T
}

// Test case 1: [a3 a2 a1 a0]
System.print("--- Test Case 1 ---")
juryC.call([1, 3.3, 4, 0.8])

// Test case 2: [a4 a3 a2 a1 a0]
System.print("\n--- Test Case 2 ---")
juryC.call([1, 1.4, 0.71, 0.154, 0.012])

// Additional test cases for printing polynomials.
System.print("\n--- Test Cases for printing polynomials ---")
var tests = [
    [1, 0, -2, 0, 5],  // z^4 - 2z^2 + 5
    [1, 1, 1],         // z^2 + z + 1
    [-1, 2.5, -3],     // -z^2 + 2.5z - 3
    [0, 0, 1, 2, 0],   // z^2 + 2z
    [5],               // constant
    [0],               // zero polynomial
    [0, 0, 0]          // zero polynomial
]
for (test in tests) System.print("    %(Fmt.spwrite("$j", test, "", "z"))")
