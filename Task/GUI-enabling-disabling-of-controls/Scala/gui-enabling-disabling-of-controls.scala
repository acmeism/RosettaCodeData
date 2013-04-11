import scala.swing._
import scala.swing.Swing._
import scala.swing.event._

object Enabling extends SimpleSwingApplication {
  def top = new MainFrame {
    title = "Rosetta Code >>> Task: GUI enabling/disabling of controls | Language: Scala"

    val numberField = new TextField { text = "0" } // start at 0

    val incButton  = new Button("Increment")

    val decButton = new Button {
      text = "Decrement"
      enabled = false
    }

    // arrange buttons in a grid with 1 row, 2 columns
    val buttonPanel = new GridPanel(1, 2) {
      contents ++= List(incButton, decButton)
    }

    // arrange text field and button panel in a grid with 2 row, 1 column
    contents = new GridPanel(2, 1) {
      contents ++= List(numberField, buttonPanel)
    }

    // backspace and delete don't cause a display of any Unicode char -
    // therefore we need to catch them apart from the others
    val specialKeys = List(Key.BackSpace, Key.Delete)

    // listen for keys pressed in numberField and button clicks
    listenTo(numberField.keys, incButton, decButton)
    reactions += {
      case kt: KeyTyped =>
        if (!kt.char.isDigit) // if the entered char isn't a digit ...
          kt.consume // ... eat the event (i.e. stop it from being processed)
        else {
          Swing.onEDT(switching) // ensure GUI-updating
        }
      case KeyPressed(_,kp,_,_) if (!specialKeys.filter(_==kp).isEmpty) =>
        Swing.onEDT(switching) // ensure GUI-updating
      case ButtonClicked(`incButton`) =>
        numberField.text = "" + (java.lang.Long.valueOf(numberField.text)+1)
        switching
      case ButtonClicked(`decButton`) =>
        numberField.text = "" + (java.lang.Long.valueOf(numberField.text)-1)
        switching
    }

    def switching: Unit = {
      val s = numberField.text match {
      			case "" => "0"
      			case _  => numberField.text
      }
      val n = java.lang.Long.valueOf(s)
      numberField.text = "" + n
      if (java.lang.Long.valueOf(numberField.text) <= 0) {
        numberField.enabled = true
        incButton.enabled = true
        decButton.enabled = false
      } else if (java.lang.Long.valueOf(numberField.text) >= 10) {
               numberField.enabled = false
               incButton.enabled = false
               decButton.enabled = true
    	     } else {
               numberField.enabled = false	
               incButton.enabled = true
               decButton.enabled = true
             }
    }
  }
}
