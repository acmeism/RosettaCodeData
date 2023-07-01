import "/big" for BigRat
import "/complex" for Complex
import "/rat" for Rat
import "/fmt" for Fmt

var tests1 = [25.000000, 24.999999, 25.000100]
var tests2 = ["-2.1e120"]
var tests3 = [-5e-2, 0/0, 1/0]
var tests4 = [Complex.fromString("5.0+0.0i"), Complex.fromString("5-5i")]
var tests5 = [Rat.new(24, 8), Rat.new(-5, 1), Rat.new(17, 2)]
var tests6 = tests1 + [-5e-2]

System.print("Using exact arithmetic:\n")
for (t in tests1) {
    Fmt.print("  $-9.6f is integer? $s", t, t.isInteger)
}
System.print()
for (t in tests2) {
    Fmt.print("  $-9s is integer? $s", t, BigRat.new(t, 1).isInteger)
}
for (t in tests3) {
    Fmt.print("  $-9.6f is integer? $s", t, t.isInteger)
}
System.print()
for (t in tests4) {
    Fmt.print("  $-9s is integer? $s", t, t.isRealInteger)
}
System.print()
for (t in tests5) {
    Fmt.print("  $-9s is integer? $s", t, t.isInteger)
}
System.print("\nWithin a tolerance of 0.00001:\n")
var tol = 0.00001
for (t in tests6) {
    var d = (t - t.round).abs
    Fmt.print("  $9.6f is integer? $s", t, d <= tol)
}
