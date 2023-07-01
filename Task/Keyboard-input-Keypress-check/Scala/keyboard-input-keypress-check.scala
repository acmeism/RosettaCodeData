import java.awt.event.{KeyAdapter, KeyEvent}

import javax.swing.{JFrame, SwingUtilities}

class KeypressCheck() extends JFrame {

  addKeyListener(new KeyAdapter() {
    override def keyPressed(e: KeyEvent): Unit = {
      val keyCode = e.getKeyCode
      if (keyCode == KeyEvent.VK_ENTER) {
        dispose()
        System.exit(0)
      }
      else
        println(keyCode)
    }
  })
}

object KeypressCheck extends App {
  println("Press any key to see its code or 'enter' to quit\n")
  SwingUtilities.invokeLater(() => {
    def foo() = {
      val f = new KeypressCheck
      f.setFocusable(true)
      f.setVisible(true)
      f.setSize(200, 200)
      f.setEnabled(true)
    }

    foo()
  })
}
