typealias FourBit = (Int, Int, Int, Int)

func halfAdder(_ a: Int, _ b: Int) -> (Int, Int) {
  return (a ^ b, a & b)
}

func fullAdder(_ a: Int, _ b: Int, carry: Int) -> (Int, Int) {
  let (s0, c0) = halfAdder(a, b)
  let (s1, c1) = halfAdder(s0, carry)

  return (s1, c0 | c1)
}

func fourBitAdder(_ a: FourBit, _ b: FourBit) -> (FourBit, carry: Int) {
  let (sum1, carry1) = halfAdder(a.3, b.3)
  let (sum2, carry2) = fullAdder(a.2, b.2, carry: carry1)
  let (sum3, carry3) = fullAdder(a.1, b.1, carry: carry2)
  let (sum4, carryOut) = fullAdder(a.0, b.0, carry: carry3)

  return ((sum4, sum3, sum2, sum1), carryOut)
}

let a = (0, 1, 1, 0)
let b = (0, 1, 1, 0)

print("\(a) + \(b) = \(fourBitAdder(a, b))")
