func bitwise(a: Int, b: Int) {
  // All bitwise operations (including shifts)
  // require both operands to be the same type
  println("a AND b: \(a & b)")
  println("a OR b: \(a | b)")
  println("a XOR b: \(a ^ b)")
  println("NOT a: \(~a)")
  println("a << b: \(a << b)") // left shift
  // for right shifts, if the operands are unsigned, Swift performs
  // a logical shift; if signed, an arithmetic shift.
  println("a >> b: \(a >> b)") // arithmetic right shift
  println("a lsr b: \(Int(bitPattern: UInt(bitPattern: a) >> UInt(bitPattern: b)))") // logical right shift
}

bitwise(-15,3)
