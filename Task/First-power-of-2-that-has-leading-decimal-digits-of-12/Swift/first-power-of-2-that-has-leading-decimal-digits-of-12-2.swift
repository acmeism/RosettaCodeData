import Foundation

func p2(L: Int, n: Int) -> Int {
  let asString = String(L)
  var digits = 1

  for _ in 1...18-asString.count {
    digits *= 10
  }

  let ten18 = Int(1e18)

  var count = 0, i = 0, probe = 1

  while true {
    probe += probe
    i += 1

    if probe >= ten18 {
      while true {
        if probe >= ten18 {
          probe /= 10
        }

        if probe / digits == L {
          count += 1

          if count >= n {
            count -= 1
            break
          }
        }

        probe += probe
        i += 1
      }
    }

    let probeString = String(probe)
    var len = asString.count

    if asString.count > probeString.count {
      len = probeString.count
    }

    if probeString.prefix(len) == asString {
      count += 1

      if count >= n {
        break
      }
    }
  }

  return i
}

let cases = [
  (12, 1),
  (12, 2),
  (123, 45),
  (123, 12345),
  (123, 678910)
]

for (l, n) in cases {
  print("p(\(l), \(n)) = \(p2(L: l, n: n))")
}
