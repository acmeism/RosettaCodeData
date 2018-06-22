import scala.annotation.tailrec

object LookAndSay extends App {

  loop(10, "1")

  @tailrec
  private def loop(n: Int, num: String): Unit = {
    println(num)
    if (n <= 0) () else loop(n - 1, lookandsay(num))
  }

  private def lookandsay(number: String): String = {
    val result = new StringBuilder

    @tailrec
    def loop(numberString: String, repeat: Char, times: Int): String =
      if (numberString.isEmpty) result.toString()
      else if (numberString.head != repeat) {
        result.append(times).append(repeat)
        loop(numberString.tail, numberString.head, 1)
      } else loop(numberString.tail, numberString.head, times + 1)

    loop(number.tail + " ", number.head, 1)
  }

}
