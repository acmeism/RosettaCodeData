object OHalloranNumbers {

  def main(args: Array[String]): Unit = {
    val maximumArea = 1_000
    val halfMaximumArea = maximumArea / 2

    var ohalloranNumbers = Array.fill[Boolean](halfMaximumArea)(true)

    for {
      length <- 1 until maximumArea
      width <- 1 until halfMaximumArea
      height <- 1 until halfMaximumArea
    } {
      val halfArea = length * width + length * height + width * height
      if (halfArea < halfMaximumArea) {
        ohalloranNumbers(halfArea) = false
      }
    }

    println("Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:")
    for {
      i <- 3 until halfMaximumArea
      if ohalloranNumbers(i)
    } {
      print(i * 2 + " ")
    }
    println()
  }
}
