func subleq(_ inst: inout [Int]) {
  var i = 0

  while i >= 0 {
    if inst[i] == -1 {
      inst[inst[i + 1]] = Int(readLine(strippingNewline: true)!.unicodeScalars.first!.value)
    } else if inst[i + 1] == -1 {
      print(String(UnicodeScalar(inst[inst[i]])!), terminator: "")
    } else {
      inst[inst[i + 1]] -= inst[inst[i]]

      if inst[inst[i + 1]] <= 0 {
        i = inst[i + 2]
        continue
      }
    }

    i += 3
  }
}

var prog = [
  15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15,
  0, 0, -1, 72, 101, 108, 108, 111, 44, 32, 119, 111,
  114, 108, 100, 33, 10, 0
]

subleq(&prog)
