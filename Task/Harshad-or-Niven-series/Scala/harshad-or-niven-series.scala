object Harshad extends App {

  val harshads = Stream from 1 filter (i => i % i.toString.map(_.asDigit).sum == 0)

  println(harshads.take(20).toList)
  println(harshads.filter(_ > 1000).head)

}
