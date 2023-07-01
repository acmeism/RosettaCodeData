import scala.io.Source

object FastPalindrome23 extends App {

  val rawText = Source.fromURL("http://oeis.org/A060792/b060792.txt")
  var count = 0

  rawText.getLines().map(_.split(" "))
    .foreach(s => {
      val n = BigInt(s(1))
      val (bin, ter) = (n.toString(2), n.toString(3))

      count += 1
      println(
        f"Decimal : ${n}%-44d , Central binary digit: ${bin(bin.length / 2)}")
      println(f"Binary  : ${bin}")
      println(f"Ternary : ${ter + " " * ((91 - ter.length) / 2)}%91s")
      println(f"Central : ${"^"}%46s%n---%n")
    })

  println(s"${count} palindromes found.")

}
