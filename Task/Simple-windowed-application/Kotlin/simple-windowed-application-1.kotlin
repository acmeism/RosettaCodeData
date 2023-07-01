// version 1.0.6

import java.awt.BorderLayout
import java.awt.event.ActionEvent
import java.awt.event.ActionListener
import javax.swing.*

class Clicks : JFrame(), ActionListener {
    private var clicks = 0
    private val label: JLabel
    private val clicker: JButton
    private var text: String

    init {
        text = "There have been no clicks yet"
        label = JLabel(text)
        clicker = JButton("click me")
        clicker.addActionListener(this)        // listen to the button
        layout = BorderLayout()                // handles placement of components
        add(label, BorderLayout.CENTER)        // add the label to the biggest section
        add(clicker, BorderLayout.SOUTH)       // put the button underneath it
        setSize(300, 200)                       // stretch out the window
        defaultCloseOperation = EXIT_ON_CLOSE  // stop the program on "X"
        isVisible = true                       // show it
    }

    override fun actionPerformed(arg0: ActionEvent) {
        if (arg0.source == clicker) {           // if they clicked the button
            if (clicks == 0) text = "There has been " + (++clicks) + " click"
            else text = "There have been " + (++clicks) + " clicks"
            label.text = text                  // change the text
        }
    }
}

fun main(args: Array<String>) {
    Clicks()  // call the constructor where all the magic happens
}
