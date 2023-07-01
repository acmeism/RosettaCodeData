import "/matrix" for Matrix
import "/fmt" for Fmt

var arrays = [
    [ [1, 3, 5],
      [2, 4, 7],
      [1, 1, 0] ],

    [ [11,  9, 24, 2],
      [ 1,  5,  2, 6],
      [ 3, 17, 18, 1],
      [ 2,  5,  7, 1] ]
]

for (array in arrays) {
    var m = Matrix.new(array)
    System.print("A\n")
    Fmt.mprint(m, 2, 0)
    System.print("\nL\n")
    var lup = m.lup
    Fmt.mprint(lup[0], 8, 5)
    System.print("\nU\n")
    Fmt.mprint(lup[1], 8, 5)
    System.print("\nP\n")
    Fmt.mprint(lup[2], 2, 0)
    System.print()
}
