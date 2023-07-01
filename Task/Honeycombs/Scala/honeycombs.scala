import java.awt.{BasicStroke, BorderLayout, Color, Dimension,
  Font, FontMetrics, Graphics, Graphics2D, Point, Polygon, RenderingHints}
import java.awt.event.{KeyAdapter, KeyEvent, MouseAdapter, MouseEvent}

import javax.swing.{JFrame, JPanel}

import scala.math.{Pi, cos, sin}

object Honeycombs extends App {
  private val (letters, x1, y1, x2, y2, h, w) = ("LRDGITPFBVOKANUYCESM", 150, 100, 225, 143, 87, 150)

  private class HoneycombsPanel() extends JPanel {
    private val comb: IndexedSeq[Hexagon] =
      for {i <- 0 until 20
           (x: Int, y: Int) =
           if (i < 12) (x1 + (i % 3) * w, y1 + (i / 3) * h)
           else (x2 + (i % 2) * w, y2 + ((i - 12) / 2) * h)
           } yield Hexagon(x, y, w / 3, letters(i))

    override def paintComponent(gg: Graphics): Unit = {
      super.paintComponent(gg)
      val g = gg.asInstanceOf[Graphics2D]
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
      g.setFont(new Font("SansSerif", Font.BOLD, 30))
      g.setStroke(new BasicStroke(3))
      comb.foreach(_.draw(g))
    }

    case class Hexagon(x: Int, y: Int, halfWidth: Int, letter: Char,
                       var hasBeenSelected: Boolean = false) extends Polygon {
      private val (baseColor, selectedColor) = (Color.yellow, Color.magenta)

      def setSelected(): Unit = hasBeenSelected = true

      def draw(g: Graphics2D): Unit = {
        val fm: FontMetrics = g.getFontMetrics
        val (asc, dec) = (fm.getAscent, fm.getDescent)

        def drawCenteredString(g: Graphics2D, s: String): Unit = {
          val x: Int = bounds.x + (bounds.width - fm.stringWidth(s)) / 2
          val y: Int = bounds.y + (asc + (bounds.height - (asc + dec)) / 2)
          g.drawString(s, x, y)
        }

        g.setColor(if (hasBeenSelected) selectedColor else baseColor)
        g.fillPolygon(this)
        g.setColor(Color.black)
        g.drawPolygon(this)
        g.setColor(if (hasBeenSelected) Color.black else Color.red)
        drawCenteredString(g, letter.toString)
      }

      for (i <- 0 until 6)
        addPoint((x + halfWidth * cos(i * Pi / 3)).toInt, (y + halfWidth * sin(i * Pi / 3)).toInt)

      getBounds
    }

    addKeyListener(new KeyAdapter() {
      override def keyPressed(e: KeyEvent): Unit = {
        val key = e.getKeyChar.toUpper
        comb.find(_.letter == key).foreach(_.setSelected())
        repaint()
      }
    })

    addMouseListener(new MouseAdapter() {
      override def mousePressed(e: MouseEvent): Unit = {
        val mousePos: Point = e.getPoint

        comb.find(h => h.contains(mousePos)).foreach(_.setSelected())
        repaint()
      }
    })

    setBackground(Color.white)
    setPreferredSize(new Dimension(600, 500))
    setFocusable(true)
    requestFocus()
  }

  new JFrame("Honeycombs") {
    add(new HoneycombsPanel(), BorderLayout.CENTER)
    pack()
    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    setLocationRelativeTo(null)
    setResizable(false)
    setVisible(true)
  }

}
