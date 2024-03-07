import "./matrix" for Matrix
import "./fmt" for Fmt

var m = Matrix.new([
    [ 1,  2,  3],
    [ 4,  5,  6],
    [ 7,  8,  9],
    [10, 11, 12]
])

System.print("Original:\n")
Fmt.mprint(m, 2, 0)
System.print("\nTransposed:\n")
Fmt.mprint(m.transpose, 2, 0)
