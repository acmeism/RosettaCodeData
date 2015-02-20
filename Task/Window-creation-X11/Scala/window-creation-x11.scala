import scala.swing.{ MainFrame, SimpleSwingApplication }
import scala.swing.Swing.pair2Dimension

object WindowExample extends SimpleSwingApplication {
  def top = new MainFrame {
    title = "Hello!"
    centerOnScreen
    preferredSize = ((200, 150))
  }
}
