import "./matrix" for Matrix
import "./fmt" for Fmt

var m = Matrix.new([[0, 1], [1, 1]])
System.print("Original:\n")
Fmt.mprint(m, 2, 0)
System.print("\nRaised to power of 10:\n")
Fmt.mprint(m ^ 10, 3, 0)
