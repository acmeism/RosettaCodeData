import java.awt.event.{KeyAdapter, KeyEvent}

import javax.swing.{JFrame, JLabel, WindowConstants}


object KeyboardMacroDemo extends App {
  val directions = "<html><b>Ctrl-S</b> to show frame title<br>" + "<b>Ctrl-H</b> to hide it</html>"

  new JFrame {
    add(new JLabel(directions))

    addKeyListener(new KeyAdapter() {
      override def keyReleased(e: KeyEvent): Unit = {
        if (e.isControlDown && e.getKeyCode == KeyEvent.VK_S) setTitle("Hello there")
        else if (e.isControlDown && e.getKeyCode == KeyEvent.VK_H) setTitle("")
      }
    })

    pack()
    setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
    setVisible(true)
  }

}
