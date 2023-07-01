import Foundation

func feigenbaum(iterations: Int = 13) {
  var a = 0.0
  var a1 = 1.0
  var a2 = 0.0
  var d = 0.0
  var d1 = 3.2

  print(" i       d")

  for i in 2...iterations {
    a = a1 + (a1 - a2) / d1

    for _ in 1...10 {
      var x = 0.0
      var y = 0.0

      for _ in 1...1<<i {
        y = 1.0 - 2.0 * y * x
        x = a - x * x
      }

      a -= x / y
    }

    d = (a1 - a2) / (a - a1)
    d1 = d
    (a1, a2) = (a, a1)

    print(String(format: "%2d    %.8f", i, d))
  }
}

feigenbaum()
