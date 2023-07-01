object Zodiac extends App {
  val years = Seq(1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017, 2018)

  private def animals =
    Seq("Rat",
      "Ox",
      "Tiger",
      "Rabbit",
      "Dragon",
      "Snake",
      "Horse",
      "Goat",
      "Monkey",
      "Rooster",
      "Dog",
      "Pig")

  private def animalChars =
    Seq("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥")

  private def elements = Seq("Wood", "Fire", "Earth", "Metal", "Water")

  private def elementChars =
    Seq(Array("甲", "丙", "戊", "庚", "壬"), Array("乙", "丁", "己", "辛", "癸"))

  private def getYY(year: Int) = if (year % 2 == 0) "yang" else "yin"

  for (year <- years) {
    println(year
      + " is the year of the " + elements(math.floor((year - 4) % 10 / 2).toInt) + " "
      + animals((year - 4) % 12)
      + " (" + getYY(year) + "). "
      + elementChars(year % 2)(math.floor((year - 4) % 10 / 2).toInt)
      + animalChars((year - 4) % 12))
  }
}
