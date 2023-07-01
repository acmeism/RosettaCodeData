import "/matrix" for Matrix
import "/fmt" for Fmt

var a = Matrix.new([
    [1, 2],
    [3, 4],
    [5, 6],
    [7, 8]
])

var b = Matrix.new([
    [1, 2, 3],
    [4, 5, 6]
])

System.print("Matrix A:\n")
Fmt.mprint(a, 2, 0)
System.print("\nMatrix B:\n")
Fmt.mprint(b, 2, 0)
System.print("\nMatrix A x B:\n")
Fmt.mprint(a * b, 3, 0)
