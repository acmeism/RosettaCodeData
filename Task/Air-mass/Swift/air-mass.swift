import Foundation

extension Double {
  var radians: Double { self * .pi / 180 }
}

func columnDensity(_ a: Double, _ z: Double) -> Double {
  func rho(_ a: Double) -> Double {
    exp(-a / 8500)
  }

  func height(_ d: Double) -> Double {
    let aa = 6_371_000 + a
    let hh = aa * aa + d * d - 2 * d * aa * cos((180 - z).radians)

    return hh.squareRoot() - 6_371_000
  }

  var sum = 0.0
  var d = 0.0

  while d < 1e7 {
    let delta = max(0.001, 0.001 * d)

    sum += rho(height(d + 0.5 * delta)) * delta
    d += delta
  }

  return sum
}

func airMass(altitude: Double, zenith: Double) -> Double {
  return columnDensity(altitude, zenith) / columnDensity(altitude, 0)
}

print("Angle     0 m              13700 m")
print("------------------------------------")

for z in stride(from: 0.0, through: 90.0, by: 5.0) {
  let air = String(
    format: "%2.0f      %11.8f      %11.8f",
    z,
    airMass(altitude: 0, zenith: z),
    airMass(altitude: 13700, zenith: z)
  )

  print(air)
}
