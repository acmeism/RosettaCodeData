import java.awt.*
import java.awt.image.BufferedImage
import javax.swing.JFrame
import javax.swing.JPanel

class JuliaPanel : JPanel() {
    init {
        preferredSize = Dimension(800, 600)
        background = Color.white
    }

    private val maxIterations = 300
    private val zoom = 1
    private val moveX = 0.0
    private val moveY = 0.0
    private val cX = -0.7
    private val cY = 0.27015

    public override fun paintComponent(graphics: Graphics) {
        super.paintComponent(graphics)
        with(graphics as Graphics2D) {
            setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
            val image = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
            (0 until width).forEach { x ->
                (0 until height).forEach { y ->
                    var zx = 1.5 * (x - width / 2) / (0.5 * zoom * width) + moveX
                    var zy = (y - height / 2) / (0.5 * zoom * height) + moveY
                    var i = maxIterations.toFloat()
                    while (zx * zx + zy * zy < 4 && i > 0) {
                        val tmp = zx * zx - zy * zy + cX
                        zy = 2.0 * zx * zy + cY
                        zx = tmp
                        i--
                    }
                    image.setRGB(x, y, Color.HSBtoRGB(maxIterations / i % 1, 1f, (if (i > 0) 1 else 0).toFloat()))
                }
            }
            drawImage(image, 0, 0, null)
        }
    }
}

fun main() {
    with(JFrame()) {
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        title = "Julia Set"
        isResizable = false
        add(JuliaPanel(), BorderLayout.CENTER)
        pack()
        setLocationRelativeTo(null)
        isVisible = true
    }
}
