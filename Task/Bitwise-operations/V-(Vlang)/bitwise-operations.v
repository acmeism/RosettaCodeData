fn bitwise(a int, b int) {
  println("a AND b: ${a & b}")
  println("a OR b: ${a | b}")
  println("a XOR b: ${a ^ b}")
  println("NOT a: ${~a}")
  println("a SHL b: ${a << b}") // left shift
  println("a SHR b: ${a >> b}") // right shift
  println("a USHR b: ${a >>> b}") // unsigned right shift
}
