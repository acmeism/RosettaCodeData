var m = []
var s = []

var optimalMatrixChainOrder = Fn.new { |dims|
    var n = dims.count - 1
    m = List.filled(n, null)
    s = List.filled(n, null)
    for (i in 0...n) {
        m[i] = List.filled(n, 0)
        s[i] = List.filled(n, 0)
    }
    for (len in 1...n) {
        for (i in 0...n-len) {
            var j = i + len
            m[i][j] = 1/0
            for (k in i...j) {
                var temp = dims[i] * dims [k + 1] * dims[j + 1]
                var cost = m[i][k] + m[k + 1][j] + temp
                if (cost < m[i][j]) {
                    m[i][j] = cost
                    s[i][j] = k
                }
            }
        }
    }
}

var printOptimalChainOrder
printOptimalChainOrder = Fn.new { |i, j|
    if (i == j) {
        System.write(String.fromByte(i + 65))
    } else {
        System.write("(")
        printOptimalChainOrder.call(i, s[i][j])
        printOptimalChainOrder.call(s[i][j] + 1, j)
        System.write(")")
    }
}

var dimsList = [
    [5, 6, 3, 1],
    [1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2],
    [1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]
]
for (dims in dimsList) {
    System.print("Dims  : %(dims)")
    optimalMatrixChainOrder.call(dims)
    System.write("Order : ")
    printOptimalChainOrder.call(0, s.count - 1)
    System.print("\nCost  : %(m[0][s.count - 1])\n")
}
