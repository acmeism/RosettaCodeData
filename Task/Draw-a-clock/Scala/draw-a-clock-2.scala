import java.time.LocalTime
import java.awt.{ Color, Graphics }

/** The Berlin clock as a Java (8.0) applet
 */
class QDclock extends java.applet.Applet with Runnable {
  val bclockThread: Thread = new Thread(this, "QDclock")

  override def init() = resize(242, 180) // fixed size, at first... doesn't work...

  override def start() = if (!bclockThread.isAlive()) bclockThread.start()

  def run() {
    while (true) {
      repaint()
      try Thread.sleep(1000) catch { case _: Throwable => sys.exit(-1) }
    }
  }

  override def update(g: Graphics) {
    val now = LocalTime.now

    def booleanToColor(cond: Boolean, colorOn: Color = Color.red): Color =
      if (cond) colorOn else Color.black

    g.setColor(booleanToColor(now.getSecond() % 2 == 0, Color.yellow))
    g.fillOval(100, 4, 40, 40)

    val (stu, min) = (now.getHour(), now.getMinute()) match {
      case (0, 0)     => (24, 0)
      case (hrs, min) => (hrs, min)
    }

    def drawRectangle(color: Color, rect: (Int, Int, Int, Int)) {
      g.setColor(color)
      g.fillRoundRect(rect._1, rect._2, rect._3, rect._4, 4, 4)
    }

    for (i <- 0 until 4) {
      drawRectangle(booleanToColor(stu / ((i + 1) * 5) > 0), (i * 60 + 2, 46, 58, 30))
      drawRectangle(booleanToColor(stu % 5 > i), (i * 60 + 2, 78, 58, 30))
      drawRectangle(booleanToColor(min % 5 > i, Color.yellow), (i * 60 + 2, 142, 58, 30))
    }

    for (i <- 0 until 11) {
      drawRectangle(booleanToColor(min / ((i + 1) * 5) > 0,
        if (2 to 8 by 3 contains i) Color.red else Color.yellow), (i * 20 + 10, 110, 18, 30))
    }
  }
}
