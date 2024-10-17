import java.awt.Color
import java.awt.Graphics
import javax.swing.JFrame

class ColorFrame(width: Int, height: Int): JFrame() {
    init {
        defaultCloseOperation = EXIT_ON_CLOSE
        setSize(width, height)
        isVisible = true
    }

    override fun paint(g: Graphics) {
        val colors = listOf(Color.black, Color.red,  Color.green,  Color.blue,
		            Color.pink,  Color.cyan, Color.yellow, Color.white)
        val size = colors.size
        for (i in 0 until size) {
            g.color = colors[i]
            g.fillRect(width / size * i, 0, width / size, height)
        }
    }
}

fun main(args: Array<String>) {
    ColorFrame(400, 400)
}
