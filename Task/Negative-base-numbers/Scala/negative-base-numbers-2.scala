def testConversion(b: Int)(n: Int, s: String): Unit = {
  println(s"$n in base -$b = ${NegativeBase.intToStr(n, b)}")
  println(s"$s from base -$b = ${NegativeBase.strToInt(s, b)}")
}

testConversion(2)(10, "11110")
testConversion(3)(146, "21102")
testConversion(10)(15, "195")
testConversion(62)(795099356, "Scala")
