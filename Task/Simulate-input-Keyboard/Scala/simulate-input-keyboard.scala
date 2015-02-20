import java.awt.Robot
import java.awt.event.KeyEvent

/** Keystrokes when this function is executed will go to whatever application has focus at the time.
 *  Special cases may need to be made for certain symbols, but most of
 *  the VK values in KeyEvent map to the ASCII values of characters.
 */

object Keystrokes extends App {
  def keystroke(str: String) {
    val robot = new Robot()
    for (ch <- str) {
      if (Character.isUpperCase(ch)) {
        robot.keyPress(KeyEvent.VK_SHIFT)
        robot.keyPress(ch)
        robot.keyRelease(ch)
        robot.keyRelease(KeyEvent.VK_SHIFT)
      } else {
        val upCh = Character.toUpperCase(ch)
        robot.keyPress(upCh)
        robot.keyRelease(upCh)
      }
    }
  }
  keystroke(args(0))
}
