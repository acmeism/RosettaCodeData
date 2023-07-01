import java.io.File
import java.util.Scanner

object ReadFastaFile extends App {
  val sc = new Scanner(new File("test.fasta"))
  var first = true

  while (sc.hasNextLine) {
    val line = sc.nextLine.trim
    if (line.charAt(0) == '>') {
      if (first) first = false
      else println()
      printf("%s: ", line.substring(1))
    }
    else print(line)
  }

  println("~~~+~~~")
}
