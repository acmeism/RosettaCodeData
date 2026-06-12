import java.io.{BufferedReader, InputStreamReader}

import scala.util.control.Breaks

object DecisionTables {
  val conditions = List(
    ("Printer prints", "NNNNYYYY"),
    ("A red light is flashing", "YYNNYYNN"),
    ("Printer is recognized by computer", "NYNYNYNY")
  )

  val actions = List(
    ("Check the power cable", "NNYNNNNN"),
    ("Check the printer-computer cable", "YNYNNNNN"),
    ("Ensure printer software is installed", "YNYNYNYN"),
    ("Check/replace ink", "YYNNNYNN"),
    ("Check for paper jam", "NYNYNNNN")
  )

  def main(args: Array[String]): Unit = {
    //    var x = (1, 2)
    //    println(x)
    //    println(conditions)
    //    println(actions)

    val nc = conditions.size
    val na = actions.size
    val nr = conditions.head._2.length
    val np = 7

    val br = new BufferedReader(new InputStreamReader(System.in))

    println("Please answer the following questions with a y or n:")
    val answers = Array.ofDim[Boolean](nc)
    for (c <- 0 until nc) {
      var input = ""
      do {
        printf("  %s ? ", conditions(c)._1)
        input = br.readLine().toUpperCase
      } while (input != "Y" && input != "N")
      answers(c) = input == "Y"
    }
    println("\nRecommended actions(s)")

    val Outer = new Breaks
    val Inner = new Breaks
    Outer.breakable {
      for (r <- 0 until nr) {
        var outer = true

        Inner.breakable {
          for (c <- 0 until nc) {
            val yn = if (answers(c)) 'Y' else 'N'
            if (conditions(c)._2(r) != yn) {
              outer = false
              Inner.break
            }
          }
        }

        if (outer) {
          if (r == np) {
            println("  None (no problem detected)")
          } else {
            for (action <- actions) {
              if (action._2(r) == 'Y') {
                printf("  %s\n", action._1)
              }
            }
          }
          Outer.break
        }
      }
    }
  }
}
