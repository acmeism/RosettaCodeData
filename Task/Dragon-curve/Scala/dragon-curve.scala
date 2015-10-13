import javax.swing.JFrame
import java.awt.Graphics

class DragonCurve(depth: Int) extends JFrame(s"Dragon Curve (depth $depth)") {

  setBounds(100, 100, 800, 600);
  setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

  val len = 400 / Math.pow(2, depth / 2.0);
  val startingAngle = -depth * (Math.PI / 4);
  val steps = getSteps(depth).filterNot(c => c == 'X' || c == 'Y')

  def getSteps(depth: Int): Stream[Char] = {
    if (depth == 0) {
      "FX".toStream
    } else {
      getSteps(depth - 1).flatMap{
        case 'X' => "XRYFR"
        case 'Y' => "LFXLY"
        case c => c.toString
      }
    }
  }

  override def paint(g: Graphics): Unit = {
    var (x, y) = (230, 350)
    var (dx, dy) = ((Math.cos(startingAngle) * len).toInt, (Math.sin(startingAngle) * len).toInt)
    for (c <- steps) c match {
      case 'F' => {
        g.drawLine(x, y, x + dx, y + dy)
        x = x + dx
        y = y + dy
      }
      case 'L' => {
        val temp = dx
        dx = dy
        dy = -temp
      }
      case 'R' => {
        val temp = dx
        dx = -dy
        dy = temp
      }
    }
  }

}

object DragonCurve extends App {
  new DragonCurve(14).setVisible(true);
}
