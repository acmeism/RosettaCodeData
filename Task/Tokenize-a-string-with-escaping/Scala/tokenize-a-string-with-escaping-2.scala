import scala.annotation.tailrec

object TokenizeStringWithEscaping1 extends App {

  def tokenize(str: String, sep: String, esc: String): Seq[String] = {
    @tailrec
    def loop(accu: Seq[String], s: String): Seq[String] = {
      def append2StringInList(char: String): Seq[String] =
        accu.init :+ (accu.last + char)

      s.length match {
        case 0 => accu
        case 1 => if (s.head.toString == sep) accu :+ "" else append2StringInList(s)
        case _ => (s.head.toString, s.tail.head.toString) match {
          case c@((`esc`, `sep`) | (`esc`, `esc`)) => loop(append2StringInList(c._2), s.tail.tail)
          case (`sep`, _)                          => loop(accu :+ "", s.tail)
          case (`esc`, _)                          => loop(accu, s.tail)
          case (sub, _)                            => loop(append2StringInList(sub.head.toString), s.tail)
        }
      }
    }

    loop(Seq(""), str)
  }

  def str = "one^|uno||three^^^^|four^^^|^cuatro|"

  tokenize(str, "|", "^")
    .foreach(it =>
      println(
        f"[length:${it.length}%3d] ${if (it.isEmpty) "<empty token>" else it}"))
}
