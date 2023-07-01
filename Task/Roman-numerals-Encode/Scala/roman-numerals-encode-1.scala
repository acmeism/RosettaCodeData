val romanDigits = Map(
  1 -> "I", 5 -> "V",
  10 -> "X", 50 -> "L",
  100 -> "C", 500 -> "D",
  1000 -> "M",
  4 -> "IV", 9 -> "IX",
  40 -> "XL", 90 -> "XC",
  400 -> "CD", 900 -> "CM")
val romanDigitsKeys = romanDigits.keysIterator.toList sortBy (x => -x)
def toRoman(n: Int): String = romanDigitsKeys find (_ >= n) match {
  case Some(key) => romanDigits(key) + toRoman(n - key)
  case None => ""
}
