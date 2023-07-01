import java.awt._
import java.awt.geom.Path2D
import java.util

import javax.swing._
import javax.swing.event.{ChangeEvent, ChangeListener}

object SuperEllipse extends App {

    SwingUtilities.invokeLater(() => {
      new JFrame("Super Ellipse") {

        class SuperEllipse extends JPanel with ChangeListener {
          setPreferredSize(new Dimension(650, 650))
          setBackground(Color.white)
          setFont(new Font("Serif", Font.PLAIN, 18))
          private var exp = 2.5

          override def paintComponent(gg: Graphics): Unit = {
            val g = gg.asInstanceOf[Graphics2D]

           def drawGrid(g: Graphics2D): Unit = {
              g.setStroke(new BasicStroke(2))
              g.setColor(new Color(0xEEEEEE))
              val w = getWidth
              val h = getHeight
              val spacing = 25

              for (i <- 0 until (w / spacing)) {
                g.drawLine(0, i * spacing, w, i * spacing)
                g.drawLine(i * spacing, 0, i * spacing, w)
              }
              g.drawLine(0, h - 1, w, h - 1)
              g.setColor(new Color(0xAAAAAA))
              g.drawLine(0, w / 2, w, w / 2)
              g.drawLine(w / 2, 0, w / 2, w)
            }

            def drawLegend(g: Graphics2D): Unit = {
              g.setColor(Color.black)
              g.setFont(getFont)
              g.drawString("n = " + String.valueOf(exp), getWidth - 150, 45)
              g.drawString("a = b = 200", getWidth - 150, 75)
            }

            def drawEllipse(g: Graphics2D): Unit = {
              val a = 200
              // calculate first quadrant
              val points = Array.tabulate(a + 1)(n =>
                math.pow(math.pow(a, exp) - math.pow(n, exp), 1 / exp))
              val p = new Path2D.Double

              p.moveTo(a, 0)
              for (n <- a to 0 by -1) p.lineTo(n, -points(n))
              // mirror to others
              for (x <- points.indices) p.lineTo(x, points(x))
              for (y <- a to 0 by -1) p.lineTo(-y, points(y))
              for (z <- points.indices) p.lineTo(-z, -points(z))
              g.translate(getWidth / 2, getHeight / 2)
              g.setStroke(new BasicStroke(2))
              g.setColor(new Color(0x25B0C4DE, true))
              g.fill(p)
              g.setColor(new Color(0xB0C4DE)) // LightSteelBlue
              g.draw(p)
            }

            super.paintComponent(gg)
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
            g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON)
            drawGrid(g)
            drawLegend(g)
            drawEllipse(g)
          }

          override def stateChanged(e: ChangeEvent): Unit = {
            val source = e.getSource.asInstanceOf[JSlider]
            exp = source.getValue / 2.0
            repaint()
          }
        }

        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
        setResizable(false)
        val panel = new SuperEllipse
        add(panel, BorderLayout.CENTER)
        val exponent = new JSlider(SwingConstants.HORIZONTAL, 1, 9, 5)
        exponent.addChangeListener(panel)
        exponent.setBackground(Color.white)
        exponent.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20))
        exponent.setMajorTickSpacing(1)
        exponent.setPaintLabels(true)
        val labelTable = new util.Hashtable[Integer, JLabel]
        for (i <- 1 until 10) labelTable.put(i, new JLabel(String.valueOf(i * 0.5)))

        exponent.setLabelTable(labelTable)
        add(exponent, BorderLayout.SOUTH)
        pack()
        setLocationRelativeTo(null)
        setVisible(true)
      }

    })

}
