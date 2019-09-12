object TernarySpecification extends Properties("Ternary") {

  property("sum") = forAll { (a: Int, b: Int) =>
    val at: Ternary = a
    val bt: Ternary = b
    (at+bt).intValue == (at.intValue + bt.intValue)
  }

  property("multiply") = forAll { (a: Int, b: Int) =>
    val at: Ternary = a
    val bt: Ternary = b
    (at*bt).intValue == (at.intValue * bt.intValue)
  }

}
