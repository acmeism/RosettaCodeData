var fact = Array(repeating: 0, count: 12)

fact[0] = 1

for n in 1..<12 {
  fact[n] = fact[n - 1] * n
}

for b in 9...12 {
  print("The factorions for base \(b) are:")

  for i in 1..<1500000 {
    var sum = 0
    var j = i

    while j > 0 {
      sum += fact[j % b]
      j /= b
    }

    if sum == i {
      print("\(i)", terminator: " ")
      fflush(stdout)
    }
  }

  print("\n")
}
