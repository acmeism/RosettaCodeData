// version 1.1

import java.awt.event.KeyAdapter
import java.awt.event.KeyEvent
import javax.swing.JFrame
import javax.swing.SwingUtilities

class Test : JFrame() {
    init {
        println("Press any key to see its code or 'enter' to quit\n")
        addKeyListener(object : KeyAdapter() {
            override fun keyPressed(e: KeyEvent) {
                if (e.keyCode == KeyEvent.VK_ENTER) {
                    isVisible = false
                   dispose()
                   System.exit(0)
                }
                else
                   println(e.keyCode)
            }
        })
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = Test()
        f.isFocusable = true
        f.isVisible = true
    }
}
