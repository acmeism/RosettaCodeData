import java.awt.print.PrinterException
import scala.swing.TextArea

object LinePrinter extends App {
  val (show, context) = (false, "Hello, World!")
  try // Default Helvetica, 12p
    new TextArea(context) {
      append(" in printing.")
      peer.print(null, null, show, null, null, show)
    }
  catch {
    case ex: PrinterException => ex.getMessage()
  }
  println("Document printed.")
}
