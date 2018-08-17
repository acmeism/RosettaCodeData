import scala.swing.Swing.pair2Dimension
import scala.swing.{Color, Graphics2D, MainFrame, Panel, SimpleSwingApplication}

object XorPattern extends SimpleSwingApplication {

  def top = new MainFrame {
    preferredSize = (300, 300)
    title = "Rosetta Code >>> Task: Munching squares | Language: Scala"
    contents = new Panel {

      protected override def paintComponent(g: Graphics2D) = {
        super.paintComponent(g)
        for {
          y <- 0 until size.getHeight.toInt
          x <- 0 until size.getWidth.toInt
        } {
          g.setColor(new Color(0, (x ^ y) % 256, 0))
          g.drawLine(x, y, x, y)
        }
      }
    }

    centerOnScreen()
  }
}
