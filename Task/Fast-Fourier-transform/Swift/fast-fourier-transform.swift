import Foundation
import Numerics

typealias Complex = Numerics.Complex<Double>

extension Complex {
  var exp: Complex {
    Complex(cos(imaginary), sin(imaginary)) * Complex(cosh(real) + sinh(real), 0)
  }

  var pretty: String {
    let fmt = { String(format: "%1.3f", $0) }
    let re = fmt(real)
    let im = fmt(abs(imaginary))

    if im == "0.000" {
      return re
    } else if re == "0.000" {
      return im
    } else if imaginary > 0 {
      return re + " + " + im + "i"
    } else {
      return re + " - " + im +  "i"
    }
  }
}

func fft(_ array: [Complex]) -> [Complex] { _fft(array, direction: Complex(0.0, 2.0), scalar: 1) }
func rfft(_ array: [Complex]) -> [Complex] { _fft(array, direction: Complex(0.0, -2.0), scalar: 2) }

private func _fft(_ arr: [Complex], direction: Complex, scalar: Double) -> [Complex] {
  guard arr.count > 1 else {
    return arr
  }

  let n = arr.count
  let cScalar = Complex(scalar, 0)

  precondition(n % 2 == 0, "The Cooley-Tukey FFT algorithm only works when the length of the input is even.")

  var (evens, odds) = arr.lazy.enumerated().reduce(into: ([Complex](), [Complex]()), {res, cur in
    if cur.offset & 1 == 0 {
      res.0.append(cur.element)
    } else {
      res.1.append(cur.element)
    }
  })

  evens = _fft(evens, direction: direction, scalar: scalar)
  odds = _fft(odds, direction: direction, scalar: scalar)

  let (left, right) = (0 ..< n / 2).map({i -> (Complex, Complex) in
    let offset = (direction * Complex((.pi * Double(i) / Double(n)), 0)).exp * odds[i] / cScalar
    let base = evens[i] / cScalar

    return (base + offset, base - offset)
  }).reduce(into: ([Complex](), [Complex]()), {res, cur in
    res.0.append(cur.0)
    res.1.append(cur.1)
  })

  return left + right
}

let dat = [Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0), Complex(1.0, 0.0),
           Complex(0.0, 0.0), Complex(0.0, 2.0), Complex(0.0, 0.0), Complex(0.0, 0.0)]

print(fft(dat).map({ $0.pretty }))
print(rfft(f).map({ $0.pretty }))
