import scala.io.StdIn

object Narcissist extends App {
  val text = scala.io.Source.fromFile("Narcissist.scala", "UTF-8").toStream
  println("Enter the number of lines to be input followed by those lines:\n")
  val n = StdIn.readInt()
  val lines = Stream {
    StdIn.readLine()
  }
  if (lines.mkString("\r\n") == text) println("\naccept") else println("\nreject")
}
