func deconv(g: [Double], f: [Double]) -> [Double] {
  let fs = f.count
  var ret = [Double](repeating: 0, count: g.count - fs + 1)

  for n in 0..<ret.count {
    ret[n] = g[n]
    let lower = n >= fs ? n - fs + 1 : 0

    for i in lower..<n {
      ret[n] -= ret[i] * f[n - i]
    }

    ret[n] /= f[0]
  }

  return ret
}

let h = [-8.0, -9.0, -3.0, -1.0, -6.0, 7.0]
let f = [-3.0, -6.0, -1.0,  8.0, -6.0,  3.0, -1.0, -9.0,
         -9.0,  3.0, -2.0,  5.0,  2.0, -2.0, -7.0, -1.0]
let g = [24.0,  75.0, 71.0, -34.0,  3.0,  22.0, -45.0,
         23.0, 245.0, 25.0,  52.0, 25.0, -67.0, -96.0,
         96.0,  31.0, 55.0,  36.0, 29.0, -43.0,  -7.0]

print("\(h.map({ Int($0) }))")
print("\(deconv(g: g, f: f).map({ Int($0) }))\n")


print("\(f.map({ Int($0) }))")
print("\(deconv(g: g, f: h).map({ Int($0) }))")
