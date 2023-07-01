func multiFactorial(_ n: Int, k: Int) -> Int {
  return stride(from: n, to: 0, by: -k).reduce(1, *)
}

let multis = (1...5).map({degree in
  (1...10).map({member in
    multiFactorial(member, k: degree)
  })
})

for (i, degree) in multis.enumerated() {
  print("Degree \(i + 1): \(degree)")
}
