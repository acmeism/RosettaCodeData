import Foundation

func normalize(_ f: Double, N: Double) -> Double {
  var a = f

  while a < -N { a += N }
  while a >= N { a -= N }

  return a
}

func normalizeToDeg(_ f: Double) -> Double {
  return normalize(f, N: 360)
}

func normalizeToGrad(_ f: Double) -> Double {
  return normalize(f, N: 400)
}

func normalizeToMil(_ f: Double) -> Double {
  return normalize(f, N: 6400)
}

func normalizeToRad(_ f: Double) -> Double {
  return normalize(f, N: 2 * .pi)
}

func d2g(_ f: Double) -> Double { f * 10 / 9 }
func d2m(_ f: Double) -> Double { f * 160 / 9 }
func d2r(_ f: Double) -> Double { f * .pi / 180 }

func g2d(_ f: Double) -> Double { f * 9 / 10 }
func g2m(_ f: Double) -> Double { f * 16 }
func g2r(_ f: Double) -> Double { f * .pi / 200 }

func m2d(_ f: Double) -> Double { f * 9 / 160 }
func m2g(_ f: Double) -> Double { f / 16 }
func m2r(_ f: Double) -> Double { f * .pi / 3200 }

func r2d(_ f: Double) -> Double { f * 180 / .pi }
func r2g(_ f: Double) -> Double { f * 200 / .pi }
func r2m(_ f: Double) -> Double { f * 3200 / .pi }

let angles = [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 6399, 1_000_000]
let names = ["Degrees", "Gradians", "Mils", "Radians"]
let fmt = { String(format: "%.4f", $0) }

let normal = [normalizeToDeg, normalizeToGrad, normalizeToMil, normalizeToRad]
let convert = [
  [{ $0 }, d2g, d2m, d2r],
  [g2d, { $0 }, g2m, g2r],
  [m2d, m2g, { $0 }, m2r],
  [r2d, r2g, r2m, { $0 }]
]

let ans =
  angles.map({ angle in
    (0..<4).map({ ($0, normal[$0](angle)) }).map({
      (fmt(angle),
        fmt($0.1),
        names[$0.0],
        fmt(convert[$0.0][0]($0.1)),
        fmt(convert[$0.0][1]($0.1)),
        fmt(convert[$0.0][2]($0.1)),
        fmt(convert[$0.0][3]($0.1))
      )
    })
  })

print("angle", "normalized", "unit", "degrees", "grads", "mils", "radians")

for res in ans {
  for unit in res {
    print(unit)
  }

  print()
}
