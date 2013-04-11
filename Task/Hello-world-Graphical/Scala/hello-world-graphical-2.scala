import swing._

object GoodbyeWorld extends SimpleSwingApplication {

  Dialog.showMessage(message = "Goodbye, World!")

  def top = new MainFrame {
    title = "Goodbye, World!"
    contents = new FlowPanel {
      contents += new Button  ("Goodbye, World!")
      contents += new TextArea("Goodbye, World!")
    }
  }
}
