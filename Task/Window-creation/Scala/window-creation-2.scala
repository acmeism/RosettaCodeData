import scala.swing._
import scala.swing.Swing._

object SimpleWindow extends SimpleSwingApplication {
  def top = new MainFrame {
    title = "Hello!"
    preferredSize = ((800, 600):Dimension)
  }
}
