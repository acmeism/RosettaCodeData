import java.awt._
import java.awt.event.ActionEvent

import javax.swing._

object ElementaryCellularAutomaton extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Elementary Cellular Automaton") {

      class ElementaryCellularAutomaton extends JPanel {
        private val dim = new Dimension(900, 450)
        private val cells = Array.ofDim[Byte](dim.height, dim.width)
        private var rule = 0

        private def ruleSet =
          Seq(30, 45, 50, 57, 62, 70, 73, 75, 86, 89, 90, 99, 101, 105, 109, 110, 124, 129, 133, 135, 137, 139, 141, 164, 170, 232)

        override def paintComponent(gg: Graphics): Unit = {
          def drawCa(g: Graphics2D): Unit = {

            def rules(lhs: Int, mid: Int, rhs: Int) = {
              val idx = lhs << 2 | mid << 1 | rhs
              (ruleSet(rule) >> idx & 1).toByte
            }

            g.setColor(Color.black)
            for (r <- 0 until cells.length - 1;
                 c <- 1 until cells(r).length - 1;
                 lhs = cells(r)(c - 1);
                 mid = cells(r)(c);
                 rhs = cells(r)(c + 1)) {
              cells(r + 1)(c) = rules(lhs, mid, rhs) // next generation
              if (cells(r)(c) == 1) g.fillRect(c, r, 1, 1)
            }
          }

          def drawLegend(g: Graphics2D): Unit = {
            val s = ruleSet(rule).toString
            val sw = g.getFontMetrics.stringWidth(ruleSet(rule).toString)
            g.setColor(Color.white)
            g.fillRect(16, 5, 55, 30)
            g.setColor(Color.darkGray)
            g.drawString(s, 16 + (55 - sw) / 2, 30)
          }

          super.paintComponent(gg)
          val g = gg.asInstanceOf[Graphics2D]
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawCa(g)
          drawLegend(g)
        }

        new Timer(5000, (_: ActionEvent) => {
          rule += 1
          if (rule == ruleSet.length) rule = 0
          repaint()
        }).start()
        cells(0)(dim.width / 2) = 1
        setBackground(Color.white)
        setFont(new Font("SansSerif", Font.BOLD, 28))
        setPreferredSize(dim)
      }

      add(new ElementaryCellularAutomaton, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    })

}
