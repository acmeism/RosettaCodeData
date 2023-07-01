object Main {

  def main(args: Array[String]): Unit = {
    val a: Ternary = "+-0++0+"
    val b: Ternary = -436
    val c: Ternary = "+-++-"
    println(a.toString + " " + a.intValue)
    println(b.toString + " " + b.intValue)
    println(c.toString + " " + c.intValue)
    val res = a * (b - c)
    println(res.toString + " " + res.intValue)
  }

}
