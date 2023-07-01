object TemperatureConversion extends App {

  def kelvinToCelsius(k: Double) = k + 273.15

  def kelvinToFahrenheit(k: Double) = k * 1.8 - 459.67

  def kelvinToRankine(k: Double) = k * 1.8

  if (args.length == 1) {
    try {
      val kelvin = args(0).toDouble
      if (kelvin >= 0) {
        println(f"K  $kelvin%2.2f")
        println(f"C  ${kelvinToCelsius(kelvin)}%2.2f")
        println(f"F  ${kelvinToFahrenheit(kelvin)}%2.2f")
        println(f"R  ${kelvinToRankine(kelvin)}%2.2f")
      } else println("%2.2f K is below absolute zero", kelvin)

    } catch {
      case e: NumberFormatException => System.out.println(e)
      case e: Throwable => {
        println("Some other exception type:")
        e.printStackTrace()
      }
    }
  } else println("Temperature not given.")
}
