import java.util.{ Timer, TimerTask }
import java.time.LocalTime
import scala.math._

object Clock extends App {
  private val (width, height) = (80, 35)

  def getGrid(localTime: LocalTime): Array[Array[Char]] = {
    val (minute, second) = (localTime.getMinute, localTime.getSecond())
    val grid = Array.fill[Char](height, width)(' ')

    def toGridCoord(x: Double, y: Double): (Int, Int) =
      (floor((y + 1.0) / 2.0 * height).toInt, floor((x + 1.0) / 2.0 * width).toInt)

    def makeText(grid: Array[Array[Char]], r: Double, theta: Double, str: String) {
      val (row, col) = toGridCoord(r * cos(theta), r * sin(theta))
      (0 until str.length).foreach(i =>
        if (row >= 0 && row < height && col + i >= 0 && col + i < width) grid(row)(col + i) = str(i))
    }

    def makeCircle(grid: Array[Array[Char]], r: Double, c: Char) {
      var theta = 0.0
      while (theta < 2 * Pi) {
        val (row, col) = toGridCoord(r * cos(theta), r * sin(theta))
        if (row >= 0 && row < height && col >= 0 && col < width) grid(row)(col) = c
        theta = theta + 0.01
      }
    }

    def makeHand(grid: Array[Array[Char]], maxR: Double, theta: Double, c: Char) {
      var r = 0.0
      while (r < maxR) {
        val (row, col) = toGridCoord(r * cos(theta), r * sin(theta))
        if (row >= 0 && row < height && col >= 0 && col < width) grid(row)(col) = c
        r = r + 0.01
      }
    }

    makeCircle(grid, 0.98, '@')
    makeHand(grid, 0.6, (localTime.getHour() + minute / 60.0 + second / 3600.0) * Pi / 6 - Pi / 2, 'O')
    makeHand(grid, 0.85, (minute + second / 60.0) * Pi / 30 - Pi / 2, '*')
    makeHand(grid, 0.90, second * Pi / 30 - Pi / 2, '.')

    (1 to 12).foreach(n => makeText(grid, 0.87, n * Pi / 6 - Pi / 2, n.toString))
    grid
  } // def getGrid(

  private val timerTask = new TimerTask {
    private def printGrid(grid: Array[Array[Char]]) = grid.foreach(row => println(row.mkString))
    def run() = printGrid(getGrid(LocalTime.now()))
  }
  (new Timer).schedule(timerTask, 0, 1000)
}
