// version 1.1

import java.awt.Toolkit
import javax.swing.JFrame

class Test : JFrame() {
    init {
        val r = Regex("""\[.*\]""")
        val toolkit = Toolkit.getDefaultToolkit()
        val screenSize = toolkit.screenSize
        println("Physical screen size : ${formatOutput(screenSize, r)}")
        val insets = toolkit.getScreenInsets(graphicsConfiguration)
        println("Insets               : ${formatOutput(insets, r)}")
        screenSize.width  -= (insets.left + insets.right)
        screenSize.height -= (insets.top + insets.bottom)
        println("Max available        : ${formatOutput(screenSize, r)}")
    }

    private fun formatOutput(output: Any, r: Regex) = r.find(output.toString())!!.value.replace(",", ", ")
}

fun main(args: Array<String>) {
    Test()
}
