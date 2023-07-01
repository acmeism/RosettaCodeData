func missingD(upTo n: Int) -> [Int] {
  var a2 = 0, s = 3, s1 = 0, s2 = 0
  var res = [Int](repeating: 0, count: n + 1)
  var ab = [Int](repeating: 0, count: n * n * 2 + 1)

  for a in 1...n {
    a2 = a * a

    for b in a...n {
      ab[a2 + b * b] = 1
    }
  }

  for c in 1..<n {
    s1 = s
    s += 2
    s2 = s

    for d in c+1...n {
      if ab[s1] != 0 {
        res[d] = 1
      }

      s1 += s2
      s2 += 2
    }
  }

  return (1...n).filter({ res[$0] == 0 })
}

print(missingD(upTo: 2200))
