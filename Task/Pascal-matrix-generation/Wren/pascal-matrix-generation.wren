import "./fmt" for Fmt
import "./math" for Int
import "./matrix" for Matrix

var binomial = Fn.new { |n, k|
    if (n == k) return 1
    var prod = 1
    var i = n - k + 1
    while (i <= n) {
        prod = prod * i
        i = i + 1
    }
    return prod / Int.factorial(k)
}

var pascalUpperTriangular = Fn.new { |n|
    var m = List.filled(n, null)
    for (i in 0...n) {
        m[i] = List.filled(n, 0)
        for (j in 0...n) m[i][j] = binomial.call(j, i)
    }
    return Matrix.new(m)
}

var pascalSymmetric = Fn.new { |n|
    var m = List.filled(n, null)
    for (i in 0...n) {
        m[i] = List.filled(n, 0)
        for (j in 0...n) m[i][j] = binomial.call(i+j, i)
    }
    return Matrix.new(m)
}

var pascalLowerTriangular = Fn.new { |n| pascalSymmetric.call(n).cholesky() }

var n = 5
System.print("Pascal upper-triangular matrix:")
Fmt.mprint(pascalUpperTriangular.call(n), 2, 0)
System.print("\nPascal lower-triangular matrix:")
Fmt.mprint(pascalLowerTriangular.call(n), 2, 0)
System.print("\nPascal symmetric matrix:")
Fmt.mprint(pascalSymmetric.call(n), 2, 0)
