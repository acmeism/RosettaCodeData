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

// Global epsilon for numerical stability checks (not the replacement epsilon).
var DEFAULT_TOLERANCE = 1e-9

// Epsilon value for replacing a zero in the first column.
var EPSILON_REPLACEMENT = 0.01

/*
    Calculates the Routh-Hurwitz stability table and determines system stability.

    Args:
        coeffVectorIn(list) : Input vector of system coefficients
                              (e.g., [an, an-1, ..., a0]).
        epssReplacement(num): Small value to replace zeros in the first column.
        tolerance      (num): Tolerance for checking if a number is zero.

    Returns:
        list: (rhTable, unstablePoles, isStable, message)
               rhTable (list)     : The Routh-Hurwitz table.
               unstablePoles (int): Number of right-hand side poles.
               isStable (bool)    : true if the system is stable, false otherwise.
               message (string)   : A message describing stability.
*/
var routhHurwitz = Fn.new { |coeffVectorIn, epssReplacement, tolerance|
    if (!((coeffVectorIn is List) && coeffVectorIn.count > 0 && (coeffVectorIn[0] is Num))) {
         System.print("\ncoeffVector must be a one dimensional, non-empty list.")
         return null
    }

    var coeffVector = coeffVectorIn.toList
    var cvc = coeffVector.count

    // Handle all-zero coefficient vector.
    if (coeffVector.all { |c| c.abs < tolerance }) {
        var numCoeffsForTable = cvc > 0 ? cvc : 1
        var rhColsTrivial = numCoeffsForTable > 0 ? (numCoeffsForTable / 2).ceil : 1
        var zeros = List.filled(numCoeffsForTable, null)
        for (i in 0...zeros.count) zeros[i] = List.filled(rhColsTrivial, 0)
        return [zeros, 0, false, "System has all zero coefficients, stability is ill-defined (considered unstable)."]
    }

    // Trim leading zeros.
    var firstNonZeroIdx = 0
    var i = 0
    for (c in coeffVector) {
        if (c.abs > tolerance) {
            firstNonZeroIdx = i
            break
        }
        if (i == cvc - 1) { // all were zero, caught by above check but as safeguard
            var rhColsTrivial = cvc > 0 ? (cvc / 2).ceil : 1
            var zeros = List.filled(cvc, null)
            for (j in 0...zeros.count) zeros[j] = List.filled(rhColsTrivial, 0)
            return [zeros, 0, false, "System has all zero coefficients after attempting to trim, stability is ill-defined (considered unstable)."]
        }
        i = i + 1
    }

    coeffVector = coeffVector[firstNonZeroIdx..-1]
    cvc = coeffVector.count

    if (cvc == 0) {  // should be caught by all-zero check if trimming led to empty
        return [[[0]], 0, false, "Coefficient vector is empty after trimming."]
    }
    if (cvc == 1) {  // zeroth order system: P(s) = a0
        var rhTableSingle = [[coeffVector[0]]]
        // A non-zero constant is stable (no roots, or root at infinity if viewed as 1/P(s)).
        // A zero constant P(s)=0 has infinite roots, unstable.
        if (coeffVector[0].abs < tolerance) {
            return [rhTableSingle, 0, false, "System is P(s)=0, unstable."] // or 1 unstable pole at origin
        }
        return [rhTableSingle, 0, true, "System is stable (0th order, non-zero constant)."]
    }

    var rhTableColumn = (cvc / 2).ceil
    // Ensure rhTableColumn is at least 1.
    rhTableColumn = Math.max(1, rhTableColumn)

    var rhTable = List.filled(cvc, null)
    for (i in 0...cvc) rhTable[i] = List.filled(rhTableColumn, 0)

    // Row 1.
    var row1Elements = []
    for (i in 0...cvc) if (i % 2 == 0) row1Elements.add(coeffVector[i])
    for (i in 0...row1Elements.count) rhTable[0][i] = row1Elements[i]

    // Row 2.
    if (cvc > 1) {
        var row2Elements = []
        for (i in 0...cvc) if (i % 2 == 1) row2Elements.add(coeffVector[i])
        if (row2Elements.count > 0) {  // check if there are any elements for the second row
           for (i in 0...row2Elements.count) rhTable[1][i] = row2Elements[i]
        }
        // If cvc is odd, row2Elements.count might be less than rhTableColumn.
        // If cvc is 1 (e.g. P(s)=s), row2Elements will be empty.
        // coeffVector = [1,0]. len=2. rh_col=1. R1=[1]. R2=[0]. Correct.
    }

    // Calculate other elements of the table.
    for (i in 2...cvc) {
        var prevRow = i - 1
        var prevPrevRow = i - 2

        // Special case: row of all zeros (check rhTable[prevRow]).
        // Effective number of columns to check for all-zero condition.
        // For row k, it's roughly rhTableColumn - (k/2).floor.
        // For simplicity:
        if (rhTable[prevRow].all { |e| e.abs < tolerance }) {
            // Auxiliary polynomial is formed from rhTable[prevPrevRow].
            // Its derivative's coefficients are placed into rhTable[prevRow].

            // Highest power of original polynomial: s^(cvc - 1).
            // Row prevPrevRow corresponds to s^((cvc -1) - prevPrevRow).
            // Highest power in aux poly: pAux = (cvc - 1) - prevPrevRow
            var highestPowerAuxPoly = (cvc - 1) - prevPrevRow

            // If highestPowerAuxPoly is 0 (constant term), derivative is 0.
            // This means rhTable[prevRow] will remain all zeros.
            // This could indicate multiple roots at origin or more complex jw-axis roots.
            if (highestPowerAuxPoly < 1) {  // aux poly is constant or invalid
                // This implies rhTable[prevPrevRow] was effectively zero or just a0.
                // If rhTable[prevRow] remains all zero, this is a problem.
                // The Routh test might break down or indicate severe instability.
                // For now, let computation proceed; if first element is zero, epss will apply.
                // But if the whole row is zero again, the next iteration might also hit this.
                // To prevent issues or signal this degenerate case:
                if (rhTable[prevPrevRow..-1].all { |e| e.abs < tolerance }) { // two consecutive all-zero rows
                    return [rhTable, cvc, false, "System unstable: Two consecutive all-zero rows encountered."]
                }
                // If aux poly source is non-zero but leads to zero derivative (e.g. it was a constant)
                // then the row prevRow remains zero. This is problematic.
                // The code below will attempt to fill it. If it stays zero, the next loop iteration
                // will find prevRow (which becomes currentRow - 1) as all zero again.
                // This recursive all-zero needs a limit or specific handling.
                // For now, if derivative is zero, the row rhTable[prevRow] is not changed from zeros.
                // Let it be, next calculations will use zeros or epss.
            }

            var allZerosGeneratedForAuxRow = true
            for (j in 0...rhTableColumn - 1) {  // iterate to fill derivative coeffs
                // Power for term rhTable[prevPrevRow][j] in aux poly is highestPowerAuxPoly - 2 * j.
                var powerOfSTerm = highestPowerAuxPoly - 2 * j
                if (powerOfSTerm >= 0) {  // differentiate valid term
                    var coeffVal = rhTable[prevPrevRow][j]
                    rhTable[prevRow][j] = powerOfSTerm * coeffVal
                    if (rhTable[prevRow][j].abs > tolerance) {
                        allZerosGeneratedForAuxRow = false
                    }
                } else {  // no more terms in aux polynomial
                    rhTable[prevRow][j] = 0
                }
            }

            if (allZerosGeneratedForAuxRow && highestPowerAuxPoly >= 1) {
                // This means aux poly was non-trivial (e.g. s^2) but all its coeffs in table were zero.
                // Or, derivative itself is identically zero (e.g. from P(s)=constant).
                // This is a critical failure point for Routh array construction.
                // A truly robust handler might stop here or flag.
                // However, we assume the derived row is used.
                // If rhTable[prevRow][0] is zero, the epss replacement will occur later for that element.
            }
        }

        // Denominator for the current row's calculation.
        var denominator = rhTable[prevRow][0]

        if (denominator.abs < tolerance) {
            // This means the first element of the previous row was zero.
            // It should have been replaced by epssReplacement in its own calculation step.
            // If it's still zero, it means epssReplacement itself might be zero,
            // or it was part of an all-zero row whose derivative was also zero at that point.
            if (epssReplacement.abs < tolerance) {  // epsilon itself is zero, cannot recover
                return [rhTable, cvc, false, "System unstable or ill-defined: Division by zero, and epsilon (%(epssReplacement)) is zero."]
            }
            denominator = epssReplacement  // use epsilon as denominator robustly
        }

        for (j in 0...rhTableColumn - 1) {
            // rhTable[i][j] = ( (rhTable[prevRow][0] * rhTable[prevPrevRow][j + 1]) -
            //                    rhTable[prevPrevRow][0] * rhTable[prevRow][j + 1]) / denominator

            // Ensure indices are within bounds for safety.
            var valPrevPrevJPlus1 =  j + 1 < rhTableColumn ? rhTable[prevPrevRow][j + 1] : 0
            var valPrevJPlus1 = j + 1 < rhTableColumn ? rhTable[prevRow][j + 1] : 0

            var numerator = rhTable[prevRow][0] * valPrevPrevJPlus1 -
                            rhTable[prevPrevRow][0] * valPrevJPlus1

            if (denominator.abs < tolerance) {  // should have been caught and set to epssReplacement
                rhTable[i][j] = Num.infinity   // should not happen if epssReplacement is non-zero
            } else {
                rhTable[i][j] = numerator / denominator
            }
        }

        // Special case: zero in the first column of the *newly computed* row (i)
        if (rhTable[i][0].abs < tolerance) {
            // Check if this row is entirely zeros. If so, it will be handled by aux poly in next iteration.
            // Applying epss here would prevent that.
            rhTable[i][0] = epssReplacement
        }
    }

    // Compute number of right hand side poles.
    var unstablePoles = 0
    var firstColumnValues = List.filled(rhTable.count, 0)
    for (k in 0...rhTable.count) firstColumnValues[k] = rhTable[k][0]

    for (k in 0...cvc - 1) {
        var signCurr = firstColumnValues[k].sign
        var signNext = firstColumnValues[k + 1].sign

        // If epssReplacement is used, it's positive, so sign is 1.
        // 0.sign is 0. product signCurr * signNext will be 0, not -1.
        if (signCurr * signNext == -1) unstablePoles = unstablePoles + 1
    }

    var isStableSystem = (unstablePoles == 0)

    // Refine stability message.
    // A row of zeros during computation (even if replaced by aux poly) indicates roots on jw-axis
    // or symmetrically located roots. If unstablePoles is 0 in such a case, it's marginally stable.
    // We don't distinguish between "stable" vs "marginally stable".
    var stabilityMessage = isStableSystem ? "System is STABLE." : "System is UNSTABLE with %(unstablePoles) pole(s) in the RHP."
    return [rhTable, unstablePoles, isStableSystem, stabilityMessage]
}

var printRouthDetails = Fn.new { |coeffVectorStrIn, rhTable, unstablePoles, isStable, message, showRoots, originalCoeffsIn, tolerance|
    System.print("\nFor coefficient vector: %(coeffVectorStrIn)")
    System.print("Routh-Hurwitz Table:")
    if (rhTable && rhTable.count > 0) {
        var rhTablePrint = List.filled(rhTable.count, null)
        for (i in 0...rhTable.count) rhTablePrint[i] = rhTable[i].toList
        // Replace very small numbers with 0 for cleaner printing.
        for (i in 0...rhTablePrint.count) {
            for (j in 0...rhTablePrint[0].count) {
                if (rhTablePrint[i][j].abs < tolerance * 10) rhTablePrint[i][j] = 0
            }
        }

        var strTableRows = []
        var maxCharLen = 0
        for (rowIdx in 0...rhTablePrint.count) {
            var strRowElems = []
            // Determine effective columns for this row to avoid printing excessive trailing zeros.
            // For strictness, print all.
            // Let's print up to the last non-zero element per row for clarity, or at least first element.
            var effectiveColsThisRow = rhTablePrint[0].count
            // Heuristic: find last significant element in this row.
            var lastSigIdx = 0
            for (colIdx in 0...rhTablePrint[0].count) {
                if (rhTablePrint[rowIdx][colIdx].abs > tolerance) lastSigIdx = colIdx
            }
            effectiveColsThisRow = Math.max(1, lastSigIdx + 1)

            for (colIdx in 0...effectiveColsThisRow) { // iterate only over effective columns
                var x = rhTablePrint[rowIdx][colIdx]
                var s = Fmt.swrite("$0.4j", x)  // general format, up to 4 significant digits
                if (s.count > maxCharLen) maxCharLen = s.count
                strRowElems.add(s)
            }
            strTableRows.add(strRowElems)
        }

        for (sre in strTableRows) {
            var formattedRowElems = []
            for (s in sre) formattedRowElems.add(Fmt.swrite("$%(maxCharLen)s", s))
            System.print(formattedRowElems.join(" | "))
        }
    } else {
        System.print("(Table generation failed or system trivial/empty)")
    }
    System.print("\n%(message)")

    if (showRoots && originalCoeffsIn) {
        var coeffsForRootsFinding = originalCoeffsIn.toList
        // Trim leading zeros for roots.
        var firstNzIdx = 0
        var i = 0
        for (c in coeffsForRootsFinding) {
            if (c.abs > tolerance) {
                firstNzIdx = i
                break
            }
            if (i == coeffsForRootsFinding.count - 1) {   // all zeros
                firstNzIdx = coeffsForRootsFinding.count  // make it empty
            }
            i = i + 1
        }
        coeffsForRootsFinding = coeffsForRootsFinding[firstNzIdx..-1]

        if (coeffsForRootsFinding.count > 1) {  // need at least s^1 + a0 = 0
            var sysRootsVal = polyRoots.call(coeffsForRootsFinding)
            if (sysRootsVal.isEmpty) {
                System.print("\nCould not compute roots (possibly due to polynomial structure).")
                return
            }
            System.print("\nRoots of the polynomial:")
            for (root in sysRootsVal) {
                if ((root is Complex) && root.imag.abs <= tolerance) { // treat as real
                    root = root.real
                }
                if (root is Complex) {
                    Fmt.print("  $0.4z", root)
                } else {
                    Fmt.print("  $0.4f", root)
                }
            }
            if (sysRootsVal.count != coeffsForRootsFinding.count - 1) {
                System.print("Note: unable to find the complex roots.")
            }
        } else if (coeffsForRootsFinding.count == 1 && coeffsForRootsFinding[0].abs > tolerance) { // P(s) = K != 0
            System.print("\nPolynomial is a non-zero constant (0th order), no roots in finite plane.")
        } else {  // P(s) = 0 or empty
            System.print("\nPolynomial is trivial (e.g., 0 or empty), roots are undefined or infinite.")
        }
    }
}

var testCases = [
    ["Stable: s^3 + 6s^2 + 11s + 6", [1, 6, 11, 6]],
    ["Unstable: s^3 - 6s^2 + 11s - 6", [1, -6, 11, -6]],
    ["Marginally Stable (jw-axis, Row of Zeros): s^3 + s^2 + s + 1", [1, 1, 1, 1]],
    ["Marginally Stable (jw-axis, Row of Zeros): s^2 + 1", [1, 0, 1]],
    ["Marginally Stable (epsilon case): s^3 + 2s^2 + s + 2", [1, 2, 1, 2]],
    ["Unstable (row of zeros & RHP): s^5 + 2s^4 + 3s^3 + 6s^2 + 5s + 10", [1, 2, 3, 6, 5, 10]],
    ["Stable: s + 1", [1, 1]],
    ["Stable: s^2 + 2s + 1", [1, 2, 1]],
    ["Unstable: s^2 - 1", [1, 0, -1]],
    ["Marginally Stable (all jw-axis): s^4 + 3s^2 + 2", [1, 0, 3, 0, 2]],
    ["All Zero Coefficients", [0, 0, 0]],
    ["Single Zero Coefficient", [0]],
    ["Single Non-Zero Coefficient (Stable)", [5]],
    ["Leading Zeros: 0s^3 + s^2 + 2s + 1", [0, 1, 2, 1]],
    ["Unstable (2 RHP): s^4 - s^3 - 7s^2 + s + 6", [1, -1, -7, 1, 6]],
    ["Marginally Stable (Ogata Example): s^6+2s^5+8s^4+12s^3+20s^2+16s+16", [1, 2, 8, 12, 20, 16, 16]],
    ["Marginally Stable (User Example): s^5+s^4+2s^3+2s^2+s+1", [1, 1, 2, 2, 1, 1]],
    ["Simplest s", [1, 0]],  //  s=0 -> one pole at origin (marginally stable)
    ["Order 0: constant", [10]],  // stable
    ["Order 0: zero", [0]],  // unstable
    ["Test case leading to problems with aux poly (constant aux poly)", [1, 1, 0, 0]]  // s^3+s^2. R1=[1,0], R2=[1,0]. R3=aux from s^2. dA/ds = 2s. R3=[2,0]. R4=0. R4 gets eps.
]

var showAllRootsMain = true
for (dc in testCases) {
    var desc = dc[0]
    var coeffsMain = dc[1]
    System.print("--- Testing Case: %(desc) ---")
    var res = routhHurwitz.call(coeffsMain, EPSILON_REPLACEMENT, DEFAULT_TOLERANCE)
    if (res) {
        var rhTable = res[0]
        var unstablePoles = res[1]
        var isStable = res[2]
        var message = res[3]
        printRouthDetails.call(coeffsMain.toString, rhTable, unstablePoles, isStable, message, showAllRootsMain, coeffsMain, DEFAULT_TOLERANCE)
    }
    System.print("-" * 60)
    System.print()
}
