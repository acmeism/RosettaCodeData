// version 1.1.2

import java.awt.Graphics
import java.awt.image.BufferedImage
import javax.swing.JFrame

class Mandelbrot: JFrame("Mandelbrot Set") {
    companion object {
        private const val MAX_ITER = 570
        private const val ZOOM = 150.0
    }

    private val img: BufferedImage

    init {
        setBounds(100, 100, 800, 600)
        isResizable = false
        defaultCloseOperation = EXIT_ON_CLOSE
        img = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
        for (y in 0 until height) {
            for (x in 0 until width) {
                var zx = 0.0
                var zy = 0.0
                val cX = (x - 400) / ZOOM
                val cY = (y - 300) / ZOOM
                var iter = MAX_ITER
                while (zx * zx + zy * zy < 4.0 && iter > 0) {
                    val tmp = zx * zx - zy * zy + cX
                    zy = 2.0 * zx * zy + cY
                    zx = tmp
                    iter--
                }
                img.setRGB(x, y, iter or (iter shl 7))
            }
        }
    }

    override fun paint(g: Graphics) {
        g.drawImage(img, 0, 0, this)
    }
}

fun main(args: Array<String>) {
    Mandelbrot().isVisible = true
}
