import java.awt.*
import java.util.concurrent.*
import javax.swing.*

class Pendulum(private val length: Int) : JPanel(), Runnable {
    init {
        val f = JFrame("Pendulum")
        f.add(this)
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.pack()
        f.isVisible = true
        isDoubleBuffered = true
    }

    override fun paint(g: Graphics) {
        with(g) {
            color = Color.WHITE
            fillRect(0, 0, width, height)
            color = Color.BLACK
            val anchor = Element(width / 2, height / 4)
            val ball = Element((anchor.x + Math.sin(angle) * length).toInt(), (anchor.y + Math.cos(angle) * length).toInt())
            drawLine(anchor.x, anchor.y, ball.x, ball.y)
            fillOval(anchor.x - 3, anchor.y - 4, 7, 7)
            fillOval(ball.x - 7, ball.y - 7, 14, 14)
        }
    }

    override fun run() {
        angleVelocity += -9.81 / length * Math.sin(angle) * dt
        angle += angleVelocity * dt
        repaint()
    }

    override fun getPreferredSize() = Dimension(2 * length + 50, length / 2 * 3)

    private data class Element(val x: Int, val y: Int)

    private val dt = 0.1
    private var angle = Math.PI / 2
    private var angleVelocity = 0.0
}

fun main(a: Array<String>) {
    val executor = Executors.newSingleThreadScheduledExecutor()
    executor.scheduleAtFixedRate(Pendulum(200), 0, 15, TimeUnit.MILLISECONDS)
}
