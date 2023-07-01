import "/matrix" for Matrix
import "/fmt" for Fmt

var m = Matrix.new([
    [ 1,  2,  -1,  -4],
    [ 2,  3,  -1, -11],
    [-2,  0,  -3,  22]
])

System.print("Original:\n")
Fmt.mprint(m, 3, 0)
System.print("\nRREF:\n")
m.toReducedRowEchelonForm
Fmt.mprint(m, 3, 0)
