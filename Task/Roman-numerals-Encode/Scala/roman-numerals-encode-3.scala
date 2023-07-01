def toRoman(num: Int): String = {
  case class RomanUnit(value: Int, token: String)
  val romanNumerals = List(
    RomanUnit(1000, "M"),
    RomanUnit(900, "CM"),
    RomanUnit(500, "D"),
    RomanUnit(400, "CD"),
    RomanUnit(100, "C"),
    RomanUnit(90, "XC"),
    RomanUnit(50, "L"),
    RomanUnit(40, "XL"),
    RomanUnit(10, "X"),
    RomanUnit(9, "IX"),
    RomanUnit(5, "V"),
    RomanUnit(4, "IV"),
    RomanUnit(1, "I"))

  var remainingNumber = num
  romanNumerals.foldLeft("") { (outputStr, romanUnit) =>
    {
      val times = remainingNumber / romanUnit.value
      remainingNumber -= romanUnit.value * times
      outputStr + (romanUnit.token * times)
    }
  }
}
