import java.awt._
import java.awt.geom.Path2D

import javax.swing._

object Pentagram extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Pentagram") {

      class Pentagram extends JPanel {
        setPreferredSize(new Dimension(640, 640))
        setBackground(Color.white)
        final private val degrees144 = Math.toRadians(144)

        override def paintComponent(gg: Graphics): Unit = {
          val g = gg.asInstanceOf[Graphics2D]

          def drawPentagram(g: Graphics2D, x: Int, y: Int, fill: Color): Unit = {
            var (_x, _y, angle) = (x, y, 0.0)
            val p = new Path2D.Float
            p.moveTo(_x, _y)
            for (i <- 0 until 5) {
              val (x2, y2) = (_x + (Math.cos(angle) * 500).toInt, _y + (Math.sin(-angle) * 500).toInt)
              p.lineTo(x2, y2)
              _x = x2
              _y = y2
              angle -= degrees144
            }
            p.closePath()
            g.setColor(fill)
            g.fill(p)
            g.setColor(Color.darkGray)
            g.draw(p)
          }

          super.paintComponent(gg)
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          g.setStroke(new BasicStroke(5, BasicStroke.CAP_ROUND, BasicStroke.JOIN_MITER))
          drawPentagram(g, 70, 250, new Color(0x6495ED))
        }
      }

      add(new Pentagram, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    }
  )

}
