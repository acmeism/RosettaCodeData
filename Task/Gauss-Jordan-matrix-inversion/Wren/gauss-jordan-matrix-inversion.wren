import "/matrix" for Matrix
import "/fmt" for Fmt

var arrays = [
    [ [ 1,  2,  3],
      [ 4,  1,  6],
      [ 7,  8,  9] ],

    [ [ 2, -1,  0 ],
      [-1,  2, -1 ],
      [ 0, -1,  2 ] ],

    [ [ -1, -2, 3, 2 ],
      [ -4, -1, 6, 2 ],
      [  7, -8, 9, 1 ],
      [  1, -2, 1, 3 ] ]
]

for (array in arrays) {
    System.print("Original:\n")
    var m = Matrix.new(array)
    Fmt.mprint(m, 2, 0)
    System.print("\nInverse:\n")
    Fmt.mprint(m.inverse, 9, 6)
    System.print()
}
