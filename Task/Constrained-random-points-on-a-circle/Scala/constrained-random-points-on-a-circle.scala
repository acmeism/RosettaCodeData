import java.awt.{ Color, geom,Graphics2D ,Rectangle}
import scala.math.hypot
import scala.swing.{MainFrame,Panel,SimpleSwingApplication}
import scala.swing.Swing.pair2Dimension
import scala.util.Random

object CirculairConstrainedRandomPoints extends SimpleSwingApplication {
  //min/max of display-x resp. y
  val dx0, dy0 = 30; val dxm, dym = 430
  val prefSizeX, prefSizeY = 480

  val palet = Map("b" -> Color.blue, "g" -> Color.green, "r" -> Color.red, "s" -> Color.black)
  val cs = List((0, 0, 10, "b"), (0, 0, 15, "g")) //circle position and color
  val xmax, ymax = 20; val xmin, ymin = -xmax

  class Coord(x: Double, y: Double) {
    def dx = (((dxm - dx0) / 2 + x.toDouble / xmax * (dxm - dx0) / 2) + dx0).toInt
    def dy = (((dym - dy0) / 2 - y.toDouble / ymax * (dym - dy0) / 2) + dy0).toInt
  }

  object Coord {
    def apply(x: Double, y: Double) = new Coord(x, y)
  }

  //points:
  val points =
    new Iterator[Int] { val r = new Random;def next = r.nextInt(31) - 15; def hasNext = true }.toStream.
      zip(new Iterator[Int] { val r = new Random; def next = r.nextInt(31) - 15; def hasNext = true }.toStream).
      map { case (x, y) => (x, y, hypot(x, y)) }.filter { case (x, y, r) => r >= 10 && r <= 15 }.take(100).toSeq.
      map { case (x, y, r) => new Rectangle(Coord(x, y).dx - 2, Coord(x, y).dy - 2, 4, 4) }

  private def ui = new Panel {
    background = Color.white
    preferredSize = (prefSizeX, prefSizeY)

    class Circle(center: Coord, r: Double, val color: Color) {
      val dr = (Coord(r, 0).dx - pcentre.dx) * 2
      val dx = center.dx - dr / 2
      val dy = center.dy - dr / 2
    }

    object Circle {
      def apply(x: Double, y: Double, r: Double, color: Color) =
        new Circle(Coord(x, y), r, color)
    }

    val pcentre = Coord(0, 0)
    val pxmax = Coord(xmax, 0); val pxmin = Coord(xmin, 0)
    val pymax = Coord(0, ymax); val pymin = Coord(0, ymin)

    //axes:
    val a_path = new geom.GeneralPath
    a_path.moveTo(pxmin.dx, pxmin.dy); a_path.lineTo(pxmax.dx, pxmax.dy) //x-axis
    a_path.moveTo(pymin.dx, pymin.dy); a_path.lineTo(pymax.dx, pymax.dy) //y-axis

    //labeling:
    val labels = List(-20, -15, -10, -5, 5, 10, 15, 20)
    labels.foreach { x => { val p = Coord(x, 0); a_path.moveTo(p.dx, p.dy - 3); a_path.lineTo(p.dx, p.dy + 3) } }
    labels.foreach { y => { val p = Coord(0, y); a_path.moveTo(p.dx - 3, p.dy); a_path.lineTo(p.dx + 3, p.dy) } }
    val xlabels = labels.map(x => { val p = Coord(x, 0); Triple(x.toString, p.dx - 3, p.dy + 20) })
    val ylabels = labels.map(y => { val p = Coord(0, y); Triple(y.toString, p.dx - 20, p.dy + 5) })

    //circles:
    val circles = cs.map { case (x, y, r, c) => Circle(x, y, r, palet(c)) }

    override def paintComponent(g: Graphics2D) = {
      super.paintComponent(g)
      circles.foreach { c => { g.setColor(c.color); g.drawOval(c.dx, c.dy, c.dr, c.dr) } }
      g.setColor(palet("r")); points.foreach(g.draw(_))
      g.setColor(palet("s")); g.draw(a_path)
      xlabels.foreach { case (text, px, py) => g.drawString(text, px, py) }
      ylabels.foreach { case (text, px, py) => g.drawString(text, px, py) }
    }
  } // def ui

  def top = new MainFrame {
    title = "Rosetta Code >>> Task: Constrained random points on a circle | Language: Scala"
    contents = ui
  }
}
