public func mianChowla(n: Int) -> [Int] {
  var mc = Array(repeating: 0, count: n)
  var ls = [2: true]
  var sum = 0

  mc[0] = 1

  for i in 1..<n {
    var lsx = [Int]()

    jLoop: for j in (mc[i-1]+1)... {
      mc[i] = j

      for k in 0...i {
        sum = mc[k] + j

        if ls[sum] ?? false {
          lsx = []
          continue jLoop
        }

        lsx.append(sum)
      }

      for n in lsx {
        ls[n] = true
      }

      break
    }
  }

  return mc
}

let seq = mianChowla(n: 100)

print("First 30 terms in sequence are: \(Array(seq.prefix(30)))")
print("Terms 91 to 100 are: \(Array(seq[90..<100]))")
