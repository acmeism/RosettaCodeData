import Foundation

typealias DFunc = (Double) -> Double

func mapRange(x: Double, min: Double, max: Double, minTo: Double, maxTo: Double) -> Double {
  return (x - min) / (max - min) * (maxTo - minTo) + minTo
}

func chebCoeffs(fun: DFunc, n: Int, min: Double, max: Double) -> [Double] {
  var res = [Double](repeating: 0, count: n)

  for i in 0..<n {
    let dI = Double(i)
    let dN = Double(n)
    let f = fun(mapRange(x: cos(.pi * (dI + 0.5) / dN), min: -1, max: 1, minTo: min, maxTo: max)) * 2.0 / dN

    for j in 0..<n {
      res[j] += f * cos(.pi * Double(j) * (dI + 0.5) / dN)
    }
  }

  return res
}

func chebApprox(x: Double, n: Int, min: Double, max: Double, coeffs: [Double]) -> Double {
  var a = 1.0
  var b = mapRange(x: x, min: min, max: max, minTo: -1, maxTo: 1)
  var res = coeffs[0] / 2.0 + coeffs[1] * b
  let xx = 2 * b
  var i = 2

  while i < n {
    let c = xx * b - a
    res += coeffs[i] * c
    (a, b) = (b, c)
    i += 1
  }

  return res
}

let coeffs = chebCoeffs(fun: cos, n: 10, min: 0, max: 1)

print("Coefficients")

for coeff in coeffs {
  print(String(format: "%+1.15g", coeff))
}

print("\nApproximations:\n  x      func(x)     approx       diff")

for i in stride(from: 0.0, through: 20, by: 1) {
  let x = mapRange(x: i, min: 0, max: 20, minTo: 0, maxTo: 1)
  let f = cos(x)
  let approx = chebApprox(x: x, n: 10, min: 0, max: 1, coeffs: coeffs)

  print(String(format: "%1.3f  %1.8f  %1.8f  % 4.1e", x, f, approx, approx - f))
}
