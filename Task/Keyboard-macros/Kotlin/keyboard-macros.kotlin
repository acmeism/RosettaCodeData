// version 1.2.31

import javax.swing.JFrame
import javax.swing.JLabel
import java.awt.event.KeyAdapter
import java.awt.event.KeyEvent

fun main(args: Array<String>) {
    val directions = "<html><b>Ctrl-S</b> to show frame title<br>" +
                     "<b>Ctrl-H</b> to hide it</html>"
    with (JFrame()) {
        add(JLabel(directions))
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        addKeyListener(object : KeyAdapter() {
            override fun keyReleased(e: KeyEvent) {
                if (e.isControlDown() && e.keyCode == KeyEvent.VK_S)
                    title = "Hello there"
                 else if( e.isControlDown() && e.keyCode == KeyEvent.VK_H)
                    title = ""
            }
        })
        pack()
        isVisible = true
    }
}
