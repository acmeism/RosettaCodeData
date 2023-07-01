object JewelsStones extends App {
  def countJewels(s: String, j: String): Int = s.count(i => j.contains(i))

  println(countJewels("aAAbbbb", "aA"))
  println(countJewels("ZZ", "z"))
}
