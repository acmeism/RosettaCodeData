// version 1.2.10

import java.awt.*
import java.awt.event.*
import java.awt.image.*
import java.util.Random
import javax.swing.*

class ImageNoise {
    var framecount = 0
    var fps = 0
    lateinit var image: BufferedImage
    val kernel: Kernel
    lateinit var cop: ConvolveOp
    val frame = JFrame("Java Image Noise")

    val panel = object : JPanel() {
        private var showFps = 0  // 0 = blur + FPS; 1 = FPS only; 2 = neither
        private val ma = object : MouseAdapter() {
            override fun mouseClicked(e: MouseEvent) {
                showFps = (showFps + 1) % 3
            }
        }

        init {
            addMouseListener(ma)
            preferredSize = Dimension(320, 240)
        }

        override fun paintComponent(g1: Graphics) {
            val g = g1 as Graphics2D
            drawNoise()
            g.drawImage(image, 0, 0, null)
            if (showFps == 0) {
                // add blur behind FPS
                val xblur = width - 130
                val yblur = height - 32
                val bc = image.getSubimage(xblur, yblur, 115, 32)
                val bs = BufferedImage(
                    bc.width, bc.height, BufferedImage.TYPE_BYTE_GRAY
                )
                cop.filter(bc, bs)
                g.drawImage(bs, xblur, yblur, null)
            }
            if (showFps <= 1) {
                // add FPS text
                g.color = Color.RED
                g.font = Font("Monospaced", Font.BOLD, 20)
                g.drawString("FPS: $fps", width - 120, height - 10)
            }
            framecount++
        }
    }

    // Timer to trigger update display, with 1 ms delay
    val repainter = Timer(1, object: ActionListener {
        override fun actionPerformed(e: ActionEvent) = panel.repaint()
    })

    // Timer to check FPS, once per second
    val framerateChecker = Timer(1000, object : ActionListener {
        override fun actionPerformed(e: ActionEvent) {
            fps = framecount
            framecount = 0
        }
    })

    init {
        // Intitalize kernel describing blur, and convolve operation based on this
        val vals = FloatArray(121) { 1.0f / 121.0f }
        kernel = Kernel(11, 11, vals)
        cop = ConvolveOp(kernel, ConvolveOp.EDGE_NO_OP, null)

        // Initialize frame and timers
        with (frame) {
            add(panel)
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            pack()
            isVisible = true
        }
        repainter.start()
        framerateChecker.start()
    }

    fun drawNoise() {
        val w = panel.width
        val h = panel.height

        // Check if our image is initialized or window has been resized,
        // requiring new image
        if (!this::image.isInitialized || image.width != w || image.height != h) {
            image = BufferedImage(w, h, BufferedImage.TYPE_BYTE_GRAY)
        }
        val rand = Random()
        val data = IntArray(w * h)
        // Each int has 32 bits so we can use each bit for a different pixel
        // - much faster
        for (x in 0 until w * h / 32) {
            var r = rand.nextInt()
            for (i in 0..31) {
                data[x * 32 + i] = (r and 1) * Int.MAX_VALUE
                r = r ushr 1
            }
        }
        // Copy raw data to the image's raster
        image.raster.setPixels(0, 0, w, h, data)
    }
}

fun main(args: Array<String>) {
    // Invoke GUI on the Event Dispatching Thread
    SwingUtilities.invokeLater(object: Runnable {
        override fun run() {
            ImageNoise()
        }
    })
}
