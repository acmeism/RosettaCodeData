import "./matrix" for Matrix

var multipleRegression = Fn.new { |y, x|
    var cy = y.transpose
    var cx = x.transpose
    return ((x * cx).inverse * x * cy).transpose[0]
}

var ys = [
    Matrix.new([ [1, 2, 3, 4, 5] ]),
    Matrix.new([ [3, 4, 5] ]),
    Matrix.new([ [52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
                  63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46] ])
]

var a = [1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83]

var xs = [
    Matrix.new([ [2, 1, 3, 4, 5] ]),
    Matrix.new([ [1, 2, 1], [1, 1, 2] ]),
    Matrix.new([ List.filled(a.count, 1), a, a.map { |e| e * e }.toList ])
]

for (i in 0...ys.count) {
    var v = multipleRegression.call(ys[i], xs[i])
    System.print(v)
    System.print()
}
