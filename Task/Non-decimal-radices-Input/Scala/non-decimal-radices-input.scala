object Main extends App {

  val (s, bases) = ("100", Seq(2, 8, 10, 16, 19, 36))
  bases.foreach(base => println(f"String $s in base $base%2d is $BigInt(s, base)%5d"))
}
