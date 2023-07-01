import java.awt.GridLayout
import java.awt.event.ActionEvent
import java.awt.event.ActionListener
import java.awt.event.KeyEvent
import java.awt.event.KeyListener
import javax.swing.*

class Interact : JFrame() {
    val numberField = JTextField()
    val incButton = JButton("Increment")
    val randButton = JButton("Random")
    val buttonPanel = JPanel()

    init {
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        numberField.text = "0"

        numberField.addKeyListener(object : KeyListener {
            override fun keyTyped(e : KeyEvent) : Unit {
                if (!Character.isDigit(e.keyChar)) e.consume()
            }
            override fun keyReleased(e : KeyEvent?) {}
            override fun keyPressed(e : KeyEvent) {}
        })

        incButton.addActionListener {
            val num = (numberField.text ?: "").toDouble()
            numberField.text = (num + 1).toString()
        }

        randButton.addActionListener(object : ActionListener {
            fun proceedOrNot() = JOptionPane.showConfirmDialog(randButton, "Are you sure?")
            override fun actionPerformed(e : ActionEvent) {
                if(proceedOrNot() == JOptionPane.YES_OPTION)
                    numberField.text = (Math.random() * Long.MAX_VALUE).toString()
            }
        })

        layout = GridLayout(2, 1)
        buttonPanel.layout = GridLayout(1, 2)
        buttonPanel.add(incButton)
        buttonPanel.add(randButton)
        add(numberField)
        add(buttonPanel)
        pack()
    }
}

fun main(args : Array<String>) {
    Interact().isVisible = true
}
