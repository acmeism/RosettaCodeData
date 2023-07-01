import java.awt._
import java.awt.image.BufferedImage

import javax.swing._

object BarnsleyFern extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Barnsley Fern") {

      private class BarnsleyFern extends JPanel {
        val dim = 640
        val img = new BufferedImage(dim, dim, BufferedImage.TYPE_INT_ARGB)

        private def createFern(w: Int, h: Int): Unit = {
          var x, y = 0.0
          for (i <- 0 until 200000) {
            var tmpx, tmpy = .0
            val r = math.random
            if (r <= 0.01) {
              tmpx = 0
              tmpy = 0.16 * y
            }
            else if (r <= 0.08) {
              tmpx = 0.2 * x - 0.26 * y
              tmpy = 0.23 * x + 0.22 * y + 1.6
            }
            else if (r <= 0.15) {
              tmpx = -0.15 * x + 0.28 * y
              tmpy = 0.26 * x + 0.24 * y + 0.44
            }
            else {
              tmpx = 0.85 * x + 0.04 * y
              tmpy = -0.04 * x + 0.85 * y + 1.6
            }
            x = tmpx
            y = tmpy
            img.setRGB((w / 2 + tmpx * w / 11).round.toInt,
              (h - tmpy * h / 11).round.toInt, 0xFF32CD32)
          }
        }

        override def paintComponent(gg: Graphics): Unit = {
          super.paintComponent(gg)
          val g = gg.asInstanceOf[Graphics2D]
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          g.drawImage(img, 0, 0, null)
        }

        setBackground(Color.white)
        setPreferredSize(new Dimension(dim, dim))
        createFern(dim, dim)
      }

      add(new BarnsleyFern, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    })

}
