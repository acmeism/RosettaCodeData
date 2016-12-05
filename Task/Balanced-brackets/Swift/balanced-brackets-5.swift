func randIsBal(n: Int) {

  let (bal, un) = ("", "un")

  for str in (1...n).map(randBrack) {

    print("\(str) is \(isBal(str) ? bal : un)balanced\n")

  }
}

randIsBal(4)
