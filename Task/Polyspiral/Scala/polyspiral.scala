import java.awt._
import java.awt.event.ActionEvent

import javax.swing._

object PolySpiral extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("PolySpiral") {

      class PolySpiral extends JPanel {
        private var inc = 0.0

        override def paintComponent(gg: Graphics): Unit = {
          val g = gg.asInstanceOf[Graphics2D]
          def drawSpiral(g: Graphics2D, l: Int, angleIncrement: Double): Unit = {
            var len = l
            var (x1, y1) = (getWidth / 2d, getHeight / 2d)
            var angle = angleIncrement
            for (i <- 0 until 150) {
              g.setColor(Color.getHSBColor(i / 150f, 1.0f, 1.0f))
              val x2 = x1 + math.cos(angle) * len
              val y2 = y1 - math.sin(angle) * len
              g.drawLine(x1.toInt, y1.toInt, x2.toInt, y2.toInt)
              x1 = x2
              y1 = y2
              len += 3
              angle = (angle + angleIncrement) % (math.Pi * 2)
            }
          }

          super.paintComponent(gg)
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawSpiral(g, 5, math.toRadians(inc))
        }

        setBackground(Color.white)
        setPreferredSize(new Dimension(640, 640))

        new Timer(40, (_: ActionEvent) => {
          inc = (inc + 0.05) % 360
          repaint()
        }).start()
      }

      add(new PolySpiral, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(true)
      setVisible(true)
    }
  )

}
