import java.awt.{BorderLayout, Color, Dimension, Font, Graphics, Graphics2D, Rectangle, RenderingHints}
import java.awt.event.{MouseAdapter, MouseEvent}

import javax.swing.{JFrame, JPanel}

object FlippingBitsGame extends App {

  class FlippingBitsGame extends JPanel {
    private val maxLevel: Int = 7
    private val box: Rectangle = new Rectangle(120, 90, 400, 400)

    private var n: Int = maxLevel

    private var grid: Array[Array[Boolean]] = _
    private var target: Array[Array[Boolean]] = _

    private var solved: Boolean = true

    override def paintComponent(gg: Graphics): Unit = {
      def drawGrid(g: Graphics2D): Unit = {
        if (solved) g.drawString("Solved! Click here to play again.", 180, 600)
        else g.drawString("Click next to a row or a column to flip.", 170, 600)
        val size: Int = box.width / n
        for {r <- 0 until n
             c <- 0 until n} {
          g.setColor(if (grid(r)(c)) Color.blue else Color.orange)
          g.fillRect(box.x + c * size, box.y + r * size, size, size)
          g.setColor(getBackground)
          g.drawRect(box.x + c * size, box.y + r * size, size, size)
          g.setColor(if (target(r)(c)) Color.blue else Color.orange)
          g.fillRect(7 + box.x + c * size, 7 + box.y + r * size, 10, 10)
        }
      }

      super.paintComponent(gg)
      val g: Graphics2D = gg.asInstanceOf[Graphics2D]
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
      drawGrid(g)
    }

    private def printGrid(msg: String, g: Array[Array[Boolean]]): Unit = {
      println(msg)
      for (row <- g) println(row.mkString(", "))
      println()
    }

    private def startNewGame(): Unit = {
      val rand = scala.util.Random

      if (solved) {
        val minLevel: Int = 3
        n = if (n == maxLevel) minLevel else n + 1
        grid = Array.ofDim[Boolean](n, n)
        target = Array.ofDim[Boolean](n, n)

        do {
          def shuffle(): Unit = for (i <- 0 until n * n)
            if (rand.nextBoolean()) flipRow(rand.nextInt(n)) else flipCol(rand.nextInt(n))

          shuffle()
          for (i <- grid.indices) grid(i).copyToArray(target(i)) //, n)
          shuffle()
        } while (solved(grid, target))
        solved = false
        printGrid("The target", target)
        printGrid("The board", grid)
      }
    }

    private def solved(a: Array[Array[Boolean]], b: Array[Array[Boolean]]): Boolean =
      a.indices.forall(i => a(i) sameElements b(i))

    private def flipRow(r: Int): Unit = for (c <- 0 until n) grid(r)(c) ^= true

    private def flipCol(c: Int): Unit = for (row <- grid) row(c) ^= true

    setPreferredSize(new Dimension(640, 640))
    setBackground(Color.white)
    setFont(new Font("SansSerif", Font.PLAIN, 18))
    startNewGame()
    addMouseListener(new MouseAdapter() {
      override def mousePressed(e: MouseEvent): Unit = {
        if (solved) startNewGame()
        else {
          val x: Int = e.getX
          val y: Int = e.getY
          if (box.contains(x, y)) return
          if (x > box.x && x < box.x + box.width) flipCol((x - box.x) / (box.width / n))
          else if (y > box.y && y < box.y + box.height) flipRow((y - box.y) / (box.height / n))
          solved = solved(grid, target)
          printGrid(if (solved) "Solved!" else "The board", grid)
        }
        repaint()
      }
    })

  }

  new JFrame("Flipping Bits Game") {
    add(new FlippingBitsGame(), BorderLayout.CENTER)
    pack()
    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    setLocationRelativeTo(null)
    setResizable(false)
    setVisible(true)
  }

}
