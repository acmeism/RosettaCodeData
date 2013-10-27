import java.awt.print.PrinterException
import javax.swing.JTextPane

object LinePrinter0 extends App {
  val show = false
  val text = """Hello, World! in printing."""
  try // Default Helvetica, 12p
    new JTextPane() { setText(text) }.print(null, null, show, null, null, show)
  catch {
    case ex: PrinterException => ex.getMessage()
  }
}
