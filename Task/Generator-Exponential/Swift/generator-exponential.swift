func powGen(m: Int) -> GeneratorOf<Int> {
  let power = Double(m)
  var cur: Double = 0
  return GeneratorOf { Int(pow(cur++, power)) }
}

var squares = powGen(2)
var cubes = powGen(3)

var nCube = cubes.next()

var filteredSqs = GeneratorOf<Int> {
  for var nSq = squares.next() ;; nCube = cubes.next() {
    if nCube > nSq {
      return nSq
    } else if nCube == nSq {
      nSq = squares.next()
    }
  }
}

extension GeneratorOf {
  func drop(n: Int) -> GeneratorOf<T> {
    var g = self
    for _ in 0..<n {g.next()}
    return GeneratorOf{g.next()}
  }
  func take(n: Int) -> GeneratorOf<T> {
    var (i, g) = (0, self)
    return GeneratorOf{++i > n ? nil : g.next()}
  }
}

for num in filteredSqs.drop(20).take(10) {
  print(num)
}

//529
//576
//625
//676
//784
//841
//900
//961
//1024
//1089
