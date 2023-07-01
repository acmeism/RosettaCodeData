import javax.swing._
import java.awt._
import java.awt.event.ActionEvent

import scala.collection.mutable
import scala.util.Random

object ChaosGame extends App {
  SwingUtilities.invokeLater(() =>
    new JFrame("Chaos Game") {

      class ChaosGame extends JPanel {
        private val (dim, margin)= (new Dimension(640, 640), 60)
        private val sizez: Int = dim.width - 2 * margin
        private val (stack, r) = (new mutable.Stack[ColoredPoint], new Random)
        private val points = Seq(new Point(dim.width / 2, margin),
          new Point(margin, sizez),
          new Point(margin + sizez, sizez)
        )
        private val colors = Seq(Color.red, Color.green, Color.blue)

        override def paintComponent(gg: Graphics): Unit = {
          val g = gg.asInstanceOf[Graphics2D]

          def drawPoints(g: Graphics2D): Unit = {
            for (p <- stack) {
              g.setColor(colors(p.colorIndex))
              g.fillOval(p.x, p.y, 1, 1)
            }
          }

          super.paintComponent(gg)
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawPoints(g)
        }


        private def addPoint(): Unit = {
          val colorIndex = r.nextInt(3)

          def halfwayPoint(a: Point, b: Point, idx: Int) =
            new ColoredPoint((a.x + b.x) / 2, (a.y + b.y) / 2, idx)

          stack.push(halfwayPoint(stack.top, points(colorIndex), colorIndex))
        }

        class ColoredPoint(x: Int, y: Int, val colorIndex: Int) extends Point(x, y)

        stack.push(new ColoredPoint(-1, -1, 0))
        new Timer(100, (_: ActionEvent) => {
          if (stack.size < 50000) {
            for (i <- 0 until 1000) addPoint()
            repaint()
          }
        }).start()
        setBackground(Color.white)
        setPreferredSize(dim)
      }

      add(new ChaosGame, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    }
  )

}
