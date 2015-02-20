import scala.swing.{ BorderPanel, Button, Label, MainFrame, SimpleSwingApplication }
import scala.swing.event.ButtonClicked

object SimpleApp extends SimpleSwingApplication {
  def top = new MainFrame {
    contents = new BorderPanel {
      var nClicks = 0

      val (button, label) = (new Button { text = "click me" },
        new Label { text = "There have been no clicks yet" })

      layout(button) = BorderPanel.Position.South
      layout(label) = BorderPanel.Position.Center
      listenTo(button)
      reactions += {
        case ButtonClicked(_) =>
          nClicks += 1
          label.text = s"There have been ${nClicks} clicks"
      }
    }
  }
}
