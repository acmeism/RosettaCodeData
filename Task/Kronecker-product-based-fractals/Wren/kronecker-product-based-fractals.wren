import "./matrix" for Matrix

var kroneckerPower = Fn.new { |m, n|
    var pow = m.copy()
    for (i in 1...n) pow = pow.kronecker(m)
    return pow
}

var printMatrix = Fn.new { |text, m|
    System.print("%(text) fractal :\n")
    for (i in 0...m.numRows) {
        for (j in 0...m.numCols) {
            System.write((m[i][j] == 1) ? "*" : " ")
        }
        System.print()
    }
    System.print()
}

var m = Matrix.new([ [0, 1, 0], [1, 1, 1], [0, 1, 0] ])
printMatrix.call("Vicsek", kroneckerPower.call(m, 4))
m = Matrix.new([ [1, 1, 1], [1, 0, 1], [1, 1, 1] ])
printMatrix.call("Sierpinski carpet", kroneckerPower.call(m, 4))
