import java.awt._
import java.awt.event.ActionEvent
import java.awt.image.BufferedImage

import javax.swing._

import scala.math.{sin, sqrt}

object PlasmaEffect extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Plasma Effect") {

      class PlasmaEffect extends JPanel {
        private val (w, h) = (640, 640)
        private var hueShift = 0.0f

        override def paintComponent(gg: Graphics): Unit = {
          val g = gg.asInstanceOf[Graphics2D]

          def drawPlasma(g: Graphics2D) = {
            val img = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)

            for (y <- 0 until h;
                 x <- 0 until w) {

              def design =
                (sin(x / 16f) + sin(y / 8f) + sin((x + y) / 16f) + sin(sqrt(x * x + y * y) / 8f) + 4).toFloat / 8

              img.setRGB(x, y, Color.HSBtoRGB(hueShift + design % 1, 1, 1))
            }
            g.drawImage(img, 0, 0, null)
          }

          super.paintComponent(gg)
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawPlasma(g)
        }

        // animate about 24 fps and shift hue value with every frame
        new Timer(42, (_: ActionEvent) => {
          hueShift = (hueShift + 0.02f) % 1
          repaint()
        }).start()

        setBackground(Color.white)
        setPreferredSize(new Dimension(h, w))
      }

      add(new PlasmaEffect, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    })

}
