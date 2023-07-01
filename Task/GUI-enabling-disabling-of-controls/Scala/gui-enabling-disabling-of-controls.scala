import swing.{ BoxPanel, Button, GridPanel, Orientation, Swing, TextField }
import swing.event.{ ButtonClicked, Key, KeyPressed, KeyTyped }

object Enabling extends swing.SimpleSwingApplication {
  def top = new swing.MainFrame {
    title = "Rosetta Code >>> Task: GUI enabling/disabling of controls | Language: Scala"

    val numberField = new TextField {
      text = "0" // start at 0
      horizontalAlignment = swing.Alignment.Right
    }

    val (incButton, decButton) = (new Button("Increment"), // Two variables initialized
      new Button("Decrement") { enabled = false })

    // arrange buttons in a grid with 1 row, 2 columns
    val buttonPanel = new GridPanel(1, 2) { contents ++= List(incButton, decButton) }

    // arrange text field and button panel in a grid with 2 row, 1 column
    contents = new BoxPanel(Orientation.Vertical) { contents ++= List(numberField, buttonPanel) }

    val specialKeys = List(Key.BackSpace, Key.Delete)

    // listen for keys pressed in numberField and button clicks
    listenTo(numberField.keys, incButton, decButton)
    reactions += {
      case kt: KeyTyped =>
        if (kt.char.isDigit) // if the entered char is a digit ...
          Swing.onEDT(switching) // ensure GUI-updating
        else kt.consume // ... eat the event (i.e. stop it from being processed)
      case KeyPressed(_, kp, _, _) if (!specialKeys.contains(kp)) =>
        Swing.onEDT(switching) // ensure GUI-updating
      case ButtonClicked(`incButton`) =>
        numberField.text = (numberField.text.toLong + 1).toString
        switching
      case ButtonClicked(`decButton`) =>
        numberField.text = (numberField.text.toLong - 1).toString
        switching
    }

    def switching = {
      val n = (if (numberField.text.isEmpty()) "0" else numberField.text).toLong
      numberField.text = n.toString
      numberField.enabled = n == 0
      incButton.enabled = n < 10
      decButton.enabled = n > 0
    }
    centerOnScreen()
  } // def top(
}
