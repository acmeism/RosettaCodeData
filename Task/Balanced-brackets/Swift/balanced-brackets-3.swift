func randBrack(n: Int) -> String {

  var bracks: [Character] = Array(Repeat(count: n, repeatedValue: "["))

  for i in UInt32(n+1)...UInt32(n + n) {

    bracks.insert("]", atIndex: Int(arc4random_uniform(i)))

  }

  return String(bracks)

}
