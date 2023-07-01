let N = 32
let N2 = N * (N - 1) / 2
let step = 0.05

var xval = [Double](repeating: 0, count: N)
var tsin = [Double](repeating: 0, count: N)
var tcos = [Double](repeating: 0, count: N)
var ttan = [Double](repeating: 0, count: N)
var rsin = [Double](repeating: .nan, count: N2)
var rcos = [Double](repeating: .nan, count: N2)
var rtan = [Double](repeating: .nan, count: N2)

func rho(_ x: [Double], _ y: [Double], _ r: inout [Double], _ i: Int, _ n: Int) -> Double {
  guard n >= 0 else {
    return 0
  }

  guard n != 0 else {
    return y[i]
  }

  let idx = (N - 1 - n) * (N - n) / 2 + i

  if r[idx] != r[idx] {
    r[idx] = (x[i] - x[i + n]) /
      (rho(x, y, &r, i, n - 1) - rho(x, y, &r, i + 1, n - 1)) + rho(x, y, &r, i + 1, n - 2)
  }

  return r[idx]
}

func thiele(_ x: [Double], _ y: [Double], _ r: inout [Double], _ xin: Double, _ n: Int) -> Double {
  guard n <= N - 1 else {
    return 1
  }

  return rho(x, y, &r, 0, n) - rho(x, y, &r, 0, n - 2) + (xin - x[n]) / thiele(x, y, &r, xin, n + 1)
}

for i in 0..<N {
  xval[i] = Double(i) * step
  tsin[i] = sin(xval[i])
  tcos[i] = cos(xval[i])
  ttan[i] = tsin[i] / tcos[i]
}

print(String(format: "%16.14f", 6 * thiele(tsin, xval, &rsin, 0.5, 0)))
print(String(format: "%16.14f", 3 * thiele(tcos, xval, &rcos, 0.5, 0)))
print(String(format: "%16.14f", 4 * thiele(ttan, xval, &rtan, 1.0, 0)))
