object NaturalSorting {
  implicit object ArrayOrdering extends Ordering[Array[String]] { // 4
    val INT = "([0-9]+)".r
    def compare(a: Array[String], b: Array[String]) = {
      val l = Math.min(a.length, b.length)
      (0 until l).prefixLength(i => a(i) equals b(i)) match {
        case i if i == l => Math.signum(b.length - a.length).toInt
        case i => (a(i), b(i)) match {
          case (INT(c), INT(d)) => Math.signum(c.toInt - d.toInt).toInt
          case (c, d) => c compareTo d
        }
      }
    }
  }

  def natural(s: String) = {
    val replacements = Map('\u00df' -> "ss", '\u017f' -> "s", '\u0292' -> "s").withDefault(s => s.toString) // 8
    import java.text.Normalizer
    Normalizer.normalize(Normalizer.normalize(
      s.trim.toLowerCase, // 1.1, 1.2, 3
      Normalizer.Form.NFKC), // 7
      Normalizer.Form.NFD).replaceAll("[\\p{InCombiningDiacriticalMarks}]", "") // 6
     .replaceAll("^(the|a|an) ", "") // 5
     .flatMap(replacements.apply) // 8
     .split(s"\\s+|(?=[0-9])(?<=[^0-9])|(?=[^0-9])(?<=[0-9])") // 1.3, 2 and 4
  }
}

object NaturalSortingTest extends App {
  import NaturalSorting._

  val tests = List(
    ("1 Ignoring leading spaces", List("ignore leading spaces: 2-2", " ignore leading spaces: 2-1", "  ignore leading spaces: 2+0", "   ignore leading spaces: 2+1"), List("  ignore leading spaces: 2+0", "   ignore leading spaces: 2+1", " ignore leading spaces: 2-1", "ignore leading spaces: 2-2")),
    ("1 Ignoring multiple adjacent spaces (m.a.s)", List("ignore m.a.s spaces: 2-2", "ignore m.a.s  spaces: 2-1", "ignore m.a.s   spaces: 2+0", "ignore m.a.s  spaces: 2+1"), List("ignore m.a.s   spaces: 2+0", "ignore m.a.s  spaces: 2+1", "ignore m.a.s  spaces: 2-1", "ignore m.a.s spaces: 2-2")),
    ("2 Equivalent whitespace characters", List("Equiv. spaces: 3-3", "Equiv.\rspaces: 3-2", "Equiv.\u000cspaces: 3-1", "Equiv.\u000bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"), List("Equiv.\u000bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2", "Equiv.\u000cspaces: 3-1", "Equiv.\rspaces: 3-2", "Equiv. spaces: 3-3")),
    ("3 Case Independent sort", List("cASE INDEPENENT: 3-2", "caSE INDEPENENT: 3-1", "casE INDEPENENT: 3+0", "case INDEPENENT: 3+1"), List("casE INDEPENENT: 3+0", "case INDEPENENT: 3+1", "caSE INDEPENENT: 3-1", "cASE INDEPENENT: 3-2")),
    ("4 Numeric fields as numerics", List("foo100bar99baz0.txt", "foo100bar10baz0.txt", "foo1000bar99baz10.txt", "foo1000bar99baz9.txt"), List("foo100bar10baz0.txt", "foo100bar99baz0.txt", "foo1000bar99baz9.txt", "foo1000bar99baz10.txt")),
    ("5 Title sorts", List("The Wind in the Willows", "The 40th step more", "The 39 steps", "Wanda"), List("The 39 steps", "The 40th step more", "Wanda", "The Wind in the Willows")),
    ("6 Equivalent accented characters (and case)", List("Equiv. \u00fd accents: 2-2", "Equiv. \u00dd accents: 2-1", "Equiv. y accents: 2+0", "Equiv. Y accents: 2+1"), List("Equiv. y accents: 2+0", "Equiv. Y accents: 2+1", "Equiv. \u00dd accents: 2-1", "Equiv. \u00fd accents: 2-2")),
    ("7 Separated ligatures", List("\u0132 ligatured ij", "no ligature"), List("\u0132 ligatured ij", "no ligature")),
    ("8 Character replacements", List("Start with an \u0292: 2-2", "Start with an \u017f: 2-1", "Start with an \u00df: 2+0", "Start with an s: 2+1"), List("Start with an s: 2+1", "Start with an \u017f: 2-1", "Start with an \u0292: 2-2", "Start with an \u00df: 2+0"))
  )

  val width = tests.flatMap(_._2).map(_.length).max
  assert(tests.forall{case (title, input, expected) =>
    val result = input.sortBy(natural)
    val okay = result == expected
    val label = if (okay) "pass" else "fail"
    println(s"$label: $title".toUpperCase)
    input.zip(result).foreach{case (a, b) => println(s"  ${a.padTo(width, ' ')}  |  ${b.padTo(width, ' ')}")}
    okay
  })
}
