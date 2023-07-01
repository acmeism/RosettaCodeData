object NDN extends App {

  val narc: Int => Int = n => (n.toString map (_.asDigit) map (math.pow(_, n.toString.size)) sum) toInt
  val isNarc: Int => Boolean = i => i == narc(i)

  println((Iterator from 0 filter isNarc take 25 toList) mkString(" "))

}
