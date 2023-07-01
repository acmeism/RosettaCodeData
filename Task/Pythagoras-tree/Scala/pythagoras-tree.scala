import java.awt._
import java.awt.geom.Path2D

import javax.swing.{JFrame, JPanel, SwingUtilities, WindowConstants}

object PythagorasTree extends App {

  SwingUtilities.invokeLater(() => {
    new JFrame {

      class PythagorasTree extends JPanel {
        setPreferredSize(new Dimension(640, 640))
        setBackground(Color.white)

        override def paintComponent(g: Graphics): Unit = {
          val (depthLimit, hue) = (7, 0.15f)

          def drawTree(g: Graphics2D, x1: Float, y1: Float, x2: Float, y2: Float, depth: Int): Unit = {
            if (depth == depthLimit) return
            val (dx, dy) = (x2 - x1, y1 - y2)
            val (x3, y3) = (x2 - dy, y2 - dx)
            val (x4, y4) = (x1 - dy, y1 - dx)
            val (x5, y5) = (x4 + 0.5F * (dx - dy), y4 - 0.5F * (dx + dy))
            val square = new Path2D.Float {
              moveTo(x1, y1); lineTo(x2, y2); lineTo(x3, y3); lineTo(x4, y4); closePath()
            }
            val triangle = new Path2D.Float {
              moveTo(x3, y3); lineTo(x4, y4); lineTo(x5, y5); closePath()
            }
            g.setColor(Color.getHSBColor(hue + depth * 0.02f, 1, 1))
            g.fill(square)
            g.setColor(Color.lightGray)
            g.draw(square)
            g.setColor(Color.getHSBColor(hue + depth * 0.035f, 1, 1))
            g.fill(triangle)
            g.setColor(Color.lightGray)
            g.draw(triangle)
            drawTree(g, x4, y4, x5, y5, depth + 1)
            drawTree(g, x5, y5, x3, y3, depth + 1)
          }

          super.paintComponent(g)
          drawTree(g.asInstanceOf[Graphics2D], 275, 500, 375, 500, 0)
        }
      }

      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setTitle("Pythagoras Tree")
      setResizable(false)
      add(new PythagorasTree, BorderLayout.CENTER)
      pack()
      setLocationRelativeTo(null)
      setVisible(true)
    }
  })

}
