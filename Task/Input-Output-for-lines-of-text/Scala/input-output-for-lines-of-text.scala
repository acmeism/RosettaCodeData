// Input/Output for Lines of Text
object IOLines extends App {
  private val in = scala.io.StdIn
  private val n = in.readInt()

  private def doStuff(word: String): Unit = println(word)

  for (_ <- 0 until n) {
    val word = in.readLine()
    doStuff(word)
  }
}
