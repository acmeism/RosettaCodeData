import swing.Dialog.{Message, showInput}
import scala.swing.Swing

object UserInput extends App {
  def responce = showInput(null,
    "Complete the sentence:\n\"Green eggs and...\"",
    "Customized Dialog",
    Message.Plain,
    Swing.EmptyIcon,
    Nil, "ham")
  println(responce)
}
