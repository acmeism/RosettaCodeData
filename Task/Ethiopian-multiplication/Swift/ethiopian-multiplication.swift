import Darwin

func ethiopian(var #int1:Int, var #int2:Int) -> Int {
  var lhs = [int1], rhs = [int2]

  func isEven(#n:Int) -> Bool {return n % 2 == 0}
  func double(#n:Int) -> Int {return n * 2}
  func halve(#n:Int) -> Int {return n / 2}

  while int1 != 1 {
    lhs.append(halve(n: int1))
    rhs.append(double(n: int2))
    int1 = halve(n: int1)
    int2 = double(n: int2)
  }

  var returnInt = 0
  for (a,b) in zip(lhs, rhs) {
    if (!isEven(n: a)) {
      returnInt += b
    }
  }
  return returnInt
}

println(ethiopian(int1: 17, int2: 34))
