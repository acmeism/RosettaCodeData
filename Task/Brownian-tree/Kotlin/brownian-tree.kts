// version 1.1.2

import java.awt.Graphics
import java.awt.image.BufferedImage
import java.util.*
import javax.swing.JFrame

class BrownianTree : JFrame("Brownian Tree"), Runnable {
    private val img: BufferedImage
    private val particles = LinkedList<Particle>()

    private companion object {
        val rand = Random()
    }

    private inner class Particle {
        private var x = rand.nextInt(img.width)
        private var y = rand.nextInt(img.height)

        /* returns true if either out of bounds or collided with tree */
        fun move(): Boolean {
            val dx = rand.nextInt(3) - 1
            val dy = rand.nextInt(3) - 1
            if ((x + dx < 0) || (y + dy < 0) || (y + dy >= img.height) ||
                (x + dx >= img.width)) return true
            x += dx
            y += dy
            if ((img.getRGB(x, y) and 0xff00) == 0xff00) {
                img.setRGB(x - dx, y - dy, 0xff00)
                return true
            }
            return false
        }
    }

    init {
        setBounds(100, 100, 400, 300)
        defaultCloseOperation = EXIT_ON_CLOSE
        img = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
        img.setRGB(img.width / 2, img.height / 2, 0xff00)
    }

    override fun paint(g: Graphics) {
        g.drawImage(img, 0, 0, this)
    }

    override fun run() {
        (0 until 20000).forEach { particles.add(Particle()) }

        while (!particles.isEmpty()) {
            val iter = particles.iterator()
            while (iter.hasNext()) {
                if (iter.next().move()) iter.remove()
            }
            repaint()
        }
    }
}

fun main(args: Array<String>) {
    val b = BrownianTree()
    b.isVisible = true
    Thread(b).start()
}
