import Foundation

func rk4(dx: Double, x: Double, y: Double, f: (Double, Double) -> Double) -> Double {
    let k1 = dx * f(x, y)
    let k2 = dx * f(x + dx / 2, y + k1 / 2)
    let k3 = dx * f(x + dx / 2, y + k2 / 2)
    let k4 = dx * f(x + dx, y + k3)

    return y + (k1 + 2 * k2 + 2 * k3 + k4) / 6
}

var y = [Double]()
var x: Double = 0.0
var y2: Double = 0.0

var x0: Double = 0.0
var x1: Double = 10.0
var dx: Double = 0.1

var i = 0
var n = Int(1 + (x1 - x0) / dx)

y.append(1)
for i in 1..<n {
    y.append(rk4(dx, x: x0 + dx * (Double(i) - 1), y: y[i - 1]) { (x: Double, y: Double) -> Double in
        return x * sqrt(y)
    })
}

print(" x         y        rel. err.")
print("------------------------------")

for (var i = 0; i < n; i += 10) {
    x = x0 + dx * Double(i)
    y2 = pow(x * x / 4 + 1, 2)

    print(String(format: "%2g  %11.6g    %11.5g", x, y[i], y[i]/y2 - 1))
}
