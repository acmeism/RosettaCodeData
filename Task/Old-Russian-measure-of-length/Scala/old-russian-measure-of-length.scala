import scala.collection.immutable.HashMap

object OldRussianLengths extends App {

  private def measures = HashMap("tochka" -> 0.000254,
    "liniya"-> 0.000254, "centimeter"-> 0.01,    "diuym"-> 0.0254, "vershok"-> 0.04445,
    "piad"  -> 0.1778,   "fut"       -> 0.3048, "arshin"-> 0.7112, "meter"  -> 1.0,
    "sazhen"-> 2.1336,   "kilometer" -> 1000.0, "versta"-> 1066.8, "milia"  -> 7467.6
  ).withDefaultValue(Double.NaN)

  if (args.length == 2 && args(0).matches("[+-]?\\d*(\\.\\d+)?")) {
    val inputVal = measures(args(1))

    def meters = args(0).toDouble * inputVal

    if (!java.lang.Double.isNaN(inputVal)) {
      printf("%s %s to: %n%n", args(0), args(1))
      for (k <- measures) println(f"${k._1}%10s:  ${meters / k._2}%g")
    }
  } else println("Please provide a number and unit on the command line.")

}
