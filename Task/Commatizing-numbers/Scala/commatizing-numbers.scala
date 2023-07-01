import java.io.File
import java.util.Scanner
import java.util.regex.Pattern

object CommatizingNumbers extends App {

  def commatize(s: String): Unit = commatize(s, 0, 3, ",")

  def commatize(s: String, start: Int, step: Int, ins: String): Unit = {
    if (start >= 0 && start <= s.length && step >= 1 && step <= s.length) {
      val m = Pattern.compile("([1-9][0-9]*)").matcher(s.substring(start))
      val result = new StringBuffer(s.substring(0, start))
      if (m.find) {
        val sb = new StringBuilder(m.group(1)).reverse
        for (i <- step until sb.length by step) sb.insert(i, ins)
        m.appendReplacement(result, sb.reverse.toString)
      }
      println(m.appendTail(result))
    }
  }

  commatize("pi=3.14159265358979323846264338327950288419716939937510582" + "097494459231", 6, 5, " ")
  commatize("The author has two Z$100000000000000 Zimbabwe notes (100 " + "trillion).", 0, 3, ".")

  val sc = new Scanner(new File("input.txt"))
  while (sc.hasNext) commatize(sc.nextLine)
}
