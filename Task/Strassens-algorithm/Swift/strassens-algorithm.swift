// Matrix Strassen Multiplication
func strassenMultiply(matrix1: Matrix, matrix2: Matrix) -> Matrix {
    precondition(matrix1.columns == matrix2.columns,
             "Two matrices can only be matrix multiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")

    // Transform to square matrix
    let maxColumns = Swift.max(matrix1.rows, matrix1.columns, matrix2.rows, matrix2.columns)
    let pwr2 = nextPowerOfTwo(num: maxColumns)
    var sqrMatrix1 = Matrix(rows: pwr2, columns: pwr2)
    var sqrMatrix2 = Matrix(rows: pwr2, columns: pwr2)

    // fill square matrix 1 with values
    for i in 0..<matrix1.rows {
        for j in 0..<matrix1.columns{
            sqrMatrix1[i, j] = matrix1[i, j]
        }
    }
    // fill square matrix 2 with values
    for i in 0..<matrix2.rows {
        for j in 0..<matrix2.columns{
            sqrMatrix2[i, j] = matrix2[i, j]
        }
    }

    // Get strassen result and transfer to array with proper size
    let formulaResult = strassenFormula(matrix1: sqrMatrix1, matrix2: sqrMatrix2)
    var finalResult = Matrix(rows: matrix1.rows, columns: matrix2.columns)
    for i in 0..<finalResult.rows{
        for j in 0..<finalResult.columns {
            finalResult[i, j] = formulaResult[i, j]
        }
    }
    return finalResult
}

// Calculate next power of 2
func nextPowerOfTwo(num: Int) -> Int {
               // formula for next power of 2
    return Int(pow(2,(ceil(log2(Double(num))))))
}

// Multiply Matrices Using Strassen Formula
func strassenFormula(matrix1: Matrix, matrix2: Matrix) -> Matrix {
    precondition(matrix1.rows == matrix1.columns && matrix2.rows == matrix2.columns, "Matrices need to be square")
    guard matrix1.rows > 1 && matrix2.rows > 1 else { return matrix1 * matrix2 }

    let rowHalf = matrix1.rows / 2
    // Strassen Formula https://www.geeksforgeeks.org/easy-way-remember-strassens-matrix-equation/
    // p1 = a(f-h)        p2 = (a+b)h
    // p2 = (c+d)e        p4 = d(g-e)
    // p5 = (a+d)(e+h)    p6 = (b-d)(g+h)
    // p7 = (a-c)(e+f)
    |a b|  x  |e f|  =  |(p5+p4-p2+p6) (p1+p2)|
    |c d|     |g h|     |(p3+p4) (p1+p5-p3-p7)|
   Matrix 1  Matrix 2          Result

    // create empty matrices for a, b, c, d, e, f, g, h
    var a = Matrix(rows: rowHalf, columns: rowHalf)
    var b = Matrix(rows: rowHalf, columns: rowHalf)
    var c = Matrix(rows: rowHalf, columns: rowHalf)
    var d = Matrix(rows: rowHalf, columns: rowHalf)
    var e = Matrix(rows: rowHalf, columns: rowHalf)
    var f = Matrix(rows: rowHalf, columns: rowHalf)
    var g = Matrix(rows: rowHalf, columns: rowHalf)
    var h = Matrix(rows: rowHalf, columns: rowHalf)

    // fill the matrices with values
    for i in 0..<rowHalf {
      for j in 0..<rowHalf {
        a[i, j] = matrix1[i, j]
        b[i, j] = matrix1[i, j+rowHalf]
        c[i, j] = matrix1[i+rowHalf, j]
        d[i, j] = matrix1[i+rowHalf, j+rowHalf]
        e[i, j] = matrix2[i, j]
        f[i, j] = matrix2[i, j+rowHalf]
        g[i, j] = matrix2[i+rowHalf, j]
        h[i, j] = matrix2[i+rowHalf, j+rowHalf]
      }
    }

     // a * (f - h)
    let p1 = strassenFormula(matrix1: a, matrix2: (f - h))
    // (a + b) * h
    let p2 = strassenFormula(matrix1: (a + b), matrix2: h)
    // (c + d) * e
    let p3 = strassenFormula(matrix1: (c + d), matrix2: e)
    // d * (g - e)
    let p4 = strassenFormula(matrix1: d, matrix2: (g - e))
    // (a + d) * (e + h)
    let p5 = strassenFormula(matrix1: (a + d), matrix2: (e + h))
    // (b - d) * (g + h)
    let p6 = strassenFormula(matrix1: (b - d), matrix2: (g + h))
    // (a - c) * (e + f)
    let p7 = strassenFormula(matrix1: (a - c), matrix2: (e + f))

    // p5 + p4 - p2 + p6
    let result11 = p5 + p4 - p2 + p6
    // p1 + p2
    let result12 = p1 + p2
    // p3 + p4
    let result21 = p3 + p4
    // p1 + p5 - p3 - p7
    let result22 = p1 + p5 - p3 - p7

    // create an empty matrix for result and fill with values
    var result = Matrix(rows: matrix1.rows, columns: matrix1.rows)
    for i in 0..<rowHalf {
      for j in 0..<rowHalf {
        result[i, j]           = result11[i, j]
        result[i, j+rowHalf]      = result12[i, j]
        result[i+rowHalf, j]      = result21[i, j]
        result[i+rowHalf, j+rowHalf] = result22[i, j]
      }
    }

    return result
}

func main(){
    // Matrix Class https://github.com/hollance/Matrix/blob/master/Matrix.swift
    var a = Matrix(rows: 2, columns: 2)
    a[row: 0] = [1, 2]
    a[row: 1] = [3, 4]

    var b = Matrix(rows: 2, columns: 2)
    b[row: 0] = [5, 6]
    b[row: 1] = [7, 8]

    var c = Matrix(rows: 4, columns: 4)
    c[row: 0] = [1, 1, 1,1]
    c[row: 1] = [2, 4, 8, 16]
    c[row: 2] = [3, 9, 27, 81]
    c[row: 3] = [4, 16, 64, 256]

    var d = Matrix(rows: 4, columns: 4)
    d[row: 0] = [4, -3, Double(4/3), Double(-1/4)]
    d[row: 1] = [Double(-13/3), Double(19/4), Double(-7/3), Double(11/24)]
    d[row: 2] = [Double(3/2), Double(-2), Double(7/6), Double(-1/4)]
    d[row: 3] = [Double(-1/6), Double(1/4), Double(-1/6), Double(1/24)]

    var e = Matrix(rows: 4, columns: 4)
    e[row: 0] = [1, 2, 3, 4]
    e[row: 1] = [5, 6, 7, 8]
    e[row: 2] = [9, 10, 11, 12]
    e[row: 3] = [13, 14, 15, 16]

    var f = Matrix(rows: 4, columns: 4)
    f[row: 0] = [1, 0, 0, 0]
    f[row: 1] = [0, 1, 0 ,0]
    f[row: 2] = [0 ,0 ,1, 0]
    f[row: 3] = [0, 0 ,0 ,1]

    let result1 = strassenMultiply(matrix1: a, matrix2: b)
    print("AxB")
    print(result1.description)
    let result2 = strassenMultiply(matrix1: c, matrix2: d)
    print("CxD")
    print(result2.description)
    let result3 = strassenMultiply(matrix1: e, matrix2: f)
    print("ExF")
    print(result3.description)
}
main()
