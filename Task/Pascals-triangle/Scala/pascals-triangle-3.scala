object Blaise extends App {
  def pascalTriangle(): Stream[Vector[Int]] =
    Vector(1) #:: Stream.iterate(Vector(1, 1))(1 +: _.sliding(2).map(_.sum).toVector :+ 1)

  val output = pascalTriangle().take(15).map(_.mkString(" "))
  val longest = output.last.length

  println("Pascal's Triangle")
  output.foreach(line => println(s"${" " * ((longest - line.length) / 2)}$line"))
}
