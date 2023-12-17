import "./complex" for Complex, CMatrix
import "./fmt" for Fmt

var cm1 = CMatrix.new(
    [
        [Complex.new(3), Complex.new(2, 1)],
        [Complex.new(2, -1), Complex.one  ]
    ]
)
var cm2 = CMatrix.fromReals([ [1, 1, 0], [0, 1, 1], [1, 0, 1] ])
var x = 2.sqrt/2
var cm3 = CMatrix.new(
    [
        [Complex.new(x), Complex.new(x), Complex.zero],
        [Complex.new(0, -x), Complex.new(0, x), Complex.zero],
        [Complex.zero, Complex.zero, Complex.imagOne]
    ]
)

for (cm in [cm1, cm2, cm3]) {
    System.print("Matrix:")
    Fmt.mprint(cm, 5, 3)
    System.print("\nConjugate transpose:")
    Fmt.mprint(cm.conjTranspose, 5, 3)
    System.print("\nHermitian : %(cm.isHermitian)")
    System.print("Normal    : %(cm.isNormal)")
    System.print("Unitary   : %(cm.isUnitary)")
    System.print()
}

System.print("For the final example if we use a tolerance of 1e-14:")
var cm4 = cm3 * cm3.conjTranspose
var id = CMatrix.identity(3)
System.print("Unitary   : %(cm4.almostEquals(id))")
