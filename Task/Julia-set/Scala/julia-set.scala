import java.awt._
import java.awt.image.BufferedImage

import javax.swing._

object JuliaSet extends App {
  SwingUtilities.invokeLater(() =>
    new JFrame("Julia Set") {

      class JuliaSet() extends JPanel {
        private val (maxIter, zoom) = (300, 1)

        override def paintComponent(gg: Graphics): Unit = {
          val g = gg.asInstanceOf[Graphics2D]

          def drawJuliaSet(g: Graphics2D): Unit = {
            val (w, h) = (getWidth, getHeight)
            val image = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
            val (cX, cY) = (-0.7, 0.27015)
            val moveX, moveY = 0
            var zx, zy = 0.0

            for (x <- 0 until w;
                 y <- 0 until h) {
              zx = 1.5 * (x - w / 2) / (0.5 * zoom * w) + moveX
              zy = (y - h / 2) / (0.5 * zoom * h) + moveY
              var i: Float = maxIter
              while (zx * zx + zy * zy < 4 && i > 0) {
                val tmp = zx * zx - zy * zy + cX
                zy = 2.0 * zx * zy + cY
                zx = tmp
                i -= 1
              }
              val c = Color.HSBtoRGB((maxIter / i) % 1, 1, if (i > 0) 1 else 0)
              image.setRGB(x, y, c)
            }
            g.drawImage(image, 0, 0, null)
          }

          super.paintComponent(gg)
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawJuliaSet(g)
        }

        setBackground(Color.white)
        setPreferredSize(new Dimension(800, 600))
      }

      add(new JuliaSet, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    }
  )

}
