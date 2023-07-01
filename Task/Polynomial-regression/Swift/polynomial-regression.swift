let x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321]

func average(_ input: [Int]) -> Int {
    return input.reduce(0, +) / input.count
}

func polyRegression(x: [Int], y: [Int]) {
    let xm = average(x)
    let ym = average(y)
    let x2m = average(x.map { $0 * $0 })
    let x3m = average(x.map { $0 * $0 * $0 })
    let x4m = average(x.map { $0 * $0 * $0 * $0 })
    let xym = average(zip(x,y).map { $0 * $1 })
    let x2ym = average(zip(x,y).map { $0 * $0 * $1 })

    let sxx = x2m - xm * xm
    let sxy = xym - xm * ym
    let sxx2 = x3m - xm * x2m
    let sx2x2 = x4m - x2m * x2m
    let sx2y = x2ym - x2m * ym

    let b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    let c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    let a = ym - b * xm - c * x2m

    func abc(xx: Int) -> Int {
        return (a + b * xx) + (c * xx * xx)
    }

    print("y = \(a) + \(b)x + \(c)x^2\n")
    print(" Input  Approximation")
    print(" x   y     y1")

    for i in 0 ..< x.count {
        let result = Double(abc(xx: i))
        print(String(format: "%2d %3d  %5.1f", x[i], y[i], result))
    }
}

polyRegression(x: x, y: y)
