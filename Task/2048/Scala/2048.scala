import java.awt.event.{KeyAdapter, KeyEvent, MouseAdapter, MouseEvent}
import java.awt.{BorderLayout, Color, Dimension, Font, Graphics2D, Graphics, RenderingHints}
import java.util.Random

import javax.swing.{JFrame, JPanel, SwingUtilities}

object Game2048 {
  val target = 2048
  var highest = 0

  def main(args: Array[String]): Unit = {
    SwingUtilities.invokeLater(() => {
      val f = new JFrame
      f.setDefaultCloseOperation(3)
      f.setTitle("2048")
      f.add(new Game, BorderLayout.CENTER)
      f.pack()
      f.setLocationRelativeTo(null)
      f.setVisible(true)
    })
  }

  class Game extends JPanel {
    private val (rand , side)= (new Random, 4)
    private var (tiles, gamestate)= (Array.ofDim[Tile](side, side), Game2048.State.start)

    final private val colorTable =
      Seq(new Color(0x701710), new Color(0xFFE4C3), new Color(0xfff4d3), new Color(0xffdac3), new Color(0xe7b08e), new Color(0xe7bf8e),
        new Color(0xffc4c3), new Color(0xE7948e), new Color(0xbe7e56), new Color(0xbe5e56), new Color(0x9c3931), new Color(0x701710))

    setPreferredSize(new Dimension(900, 700))
    setBackground(new Color(0xFAF8EF))
    setFont(new Font("SansSerif", Font.BOLD, 48))
    setFocusable(true)
    addMouseListener(new MouseAdapter() {
      override def mousePressed(e: MouseEvent): Unit = {
        startGame()
        repaint()
      }
    })
    addKeyListener(new KeyAdapter() {
      override def keyPressed(e: KeyEvent): Unit = {
        e.getKeyCode match {
          case KeyEvent.VK_UP => moveUp()
          case KeyEvent.VK_DOWN => moveDown()
          case KeyEvent.VK_LEFT => moveLeft()
          case KeyEvent.VK_RIGHT => moveRight()
          case _ =>
        }
        repaint()
      }
    })

    override def paintComponent(gg: Graphics): Unit = {
      super.paintComponent(gg)
      val g = gg.asInstanceOf[Graphics2D]
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
      drawGrid(g)
    }

    private def drawGrid(g: Graphics2D): Unit = {
      val (gridColor, emptyColor, startColor) = (new Color(0xBBADA0), new Color(0xCDC1B4), new Color(0xFFEBCD))

      if (gamestate == State.running) {
        g.setColor(gridColor)
        g.fillRoundRect(200, 100, 499, 499, 15, 15)
        for (
          r <- 0 until side;
          c <- 0 until side
        ) if (Option(tiles(r)(c)).isEmpty) {
          g.setColor(emptyColor)
          g.fillRoundRect(215 + c * 121, 115 + r * 121, 106, 106, 7, 7)
        }
        else drawTile(g, r, c)
      } else {
        g.setColor(startColor)
        g.fillRoundRect(215, 115, 469, 469, 7, 7)
        g.setColor(gridColor.darker)
        g.setFont(new Font("SansSerif", Font.BOLD, 128))
        g.drawString("2048", 310, 270)
        g.setFont(new Font("SansSerif", Font.BOLD, 20))
        if (gamestate == Game2048.State.won) g.drawString("you made it!", 390, 350)
        else if (gamestate == Game2048.State.over) g.drawString("game over", 400, 350)
        g.setColor(gridColor)
        g.drawString("click to start a new game", 330, 470)
        g.drawString("(use arrow keys to move tiles)", 310, 530)
      }
    }

    private def drawTile(g: Graphics2D, r: Int, c: Int): Unit = {
      val value = tiles(r)(c).value
      g.setColor(colorTable((math.log(value) / math.log(2)).toInt + 1))
      g.fillRoundRect(215 + c * 121, 115 + r * 121, 106, 106, 7, 7)
      g.setColor(if (value < 128) colorTable.head else colorTable(1))
      val (s , fm)= (value.toString, g.getFontMetrics)
      val asc = fm.getAscent
      val (x, y) = (215 + c * 121 + (106 - fm.stringWidth(s)) / 2,115 + r * 121 + (asc + (106 - (asc + fm.getDescent)) / 2))
      g.drawString(s, x, y)
    }

    private def moveUp(checkingAvailableMoves: Boolean = false) = move(0, -1, 0, checkingAvailableMoves)

    private def moveDown(checkingAvailableMoves: Boolean = false) = move(side * side - 1, 1, 0, checkingAvailableMoves)

    private def moveLeft(checkingAvailableMoves: Boolean = false) = move(0, 0, -1, checkingAvailableMoves)

    private def moveRight(checkingAvailableMoves: Boolean = false) = move(side * side - 1, 0, 1, checkingAvailableMoves)

    private def clearMerged(): Unit = for (row <- tiles; tile <- row) if (Option(tile).isDefined) tile.setMerged()

    private def movesAvailable() = moveUp(true) || moveDown(true) || moveLeft(true) || moveRight(true)

    def move(countDownFrom: Int, yIncr: Int, xIncr: Int, checkingAvailableMoves: Boolean): Boolean = {
      var moved = false
      for (i <- 0 until side * side) {
        val j = math.abs(countDownFrom - i)
        var( r,c) = (j / side,  j % side)
        if (Option(tiles(r)(c)).isDefined) {
          var (nextR, nextC, breek) = (r + yIncr, c + xIncr, false)
          while ((nextR >= 0 && nextR < side && nextC >= 0 && nextC < side) && !breek) {
            val (next, curr) = (tiles(nextR)(nextC),tiles(r)(c))
            if (Option(next).isEmpty)
              if (checkingAvailableMoves) return true
              else {
                tiles(nextR)(nextC) = curr
                tiles(r)(c) = null
                r = nextR
                c = nextC
                nextR += yIncr
                nextC += xIncr
                moved = true
              }
            else if (next.canMergeWith(curr)) {
              if (checkingAvailableMoves) return true
              Game2048.highest = math.max(next.mergeWith(curr), Game2048.highest)
              tiles(r)(c) = null
              breek = true
              moved = true
            } else breek = true
          }
        }
      }
      if (moved) if (Game2048.highest < Game2048.target) {
        clearMerged()
        addRandomTile()
        if (!movesAvailable) gamestate = State.over
      }
      else if (Game2048.highest == Game2048.target) gamestate = State.won
      moved
    }

    private def startGame(): Unit = {
      if (gamestate ne Game2048.State.running) {
        Game2048.highest = 0
        gamestate = Game2048.State.running
        tiles = Array.ofDim[Tile](side, side)
        addRandomTile()
        addRandomTile()
      }
    }

    private def addRandomTile(): Unit = {
      var pos = rand.nextInt(side * side)
      var (row, col) = (0, 0)
      do {
        pos = (pos + 1) % (side * side)
        row = pos / side
        col = pos % side
      } while (Option(tiles(row)(col)).isDefined)
      tiles(row)(col) = new Tile(if (rand.nextInt(10) == 0) 4 else 2)
    }

    class Tile(var value: Int) {
      private var merged = false

      def setMerged(): Unit = merged = false

      def mergeWith(other: Tile): Int = if (canMergeWith(other)) {
        merged = true
        value *= 2
        value
      } else -1

      def canMergeWith(other: Tile): Boolean = !merged && Option(other).isDefined && !other.merged && value == other.value
    }
  }

  object State extends Enumeration {
    type State = Value
    val start, won, running, over = Value
  }

}
