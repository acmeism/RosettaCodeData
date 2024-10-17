// version 1.1

import javax.swing.JOptionPane

fun main(args: Array<String>) {
    do {
        val number = JOptionPane.showInputDialog("Enter 75000").toInt()
    } while (number != 75000)
}
