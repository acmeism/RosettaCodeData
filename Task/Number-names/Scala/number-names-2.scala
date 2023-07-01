import scala.collection.immutable.TreeMap

val NUMBERS = TreeMap(
  1 -> "one", 2 -> "two", 3 -> "three", 4 -> "four", 5 -> "five", 6 -> "six", 7 -> "seven", 8 -> "eight", 9 -> "nine",
  10 -> "ten", 11 -> "eleven", 12 -> "twelve", 13 -> "thirteen", 14 -> "fourteen", 15 -> "fifteen", 16 -> "sixteen",
  17 -> "seventeen", 18 -> "eighteen", 19 -> "nineteen", 20 -> "twenty", 30 -> "thirty", 40 -> "forty",
  50 -> "fifty", 60 -> "sixty", 70 -> "seventy", 80 -> "eighty", 90 -> "ninety"
)

val HUNDREDS = TreeMap(
  100l -> "hundred", 1000l -> "thousand", 1000000l -> "million", 1000000000l -> "billion", 1000000000000l -> "trillion"
)

def numberToString(number: Long) : String = {
  if (HUNDREDS.to(number).nonEmpty) {
    val (h, hundreds) = HUNDREDS.to(number).last
    val remainder = number % h
    numberToString(number / h) + hundreds + {if (remainder > 0) {if (remainder < 100) " and " else ", "} + numberToString(remainder) else " "}
  } else if (NUMBERS.to(number.toInt).nonEmpty) {
    val (n, word) = NUMBERS.to(number.toInt).last
    val remainder = number - n
    word + {if (remainder > 0 && remainder < 10) "-" else " "} + numberToString(remainder)
  } else {
    ""
  }
}
