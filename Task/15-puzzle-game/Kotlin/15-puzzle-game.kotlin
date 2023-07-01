// version 1.1.3

import java.awt.BorderLayout
import java.awt.Color
import java.awt.Dimension
import java.awt.Font
import java.awt.Graphics
import java.awt.Graphics2D
import java.awt.RenderingHints
import java.awt.event.MouseAdapter
import java.awt.event.MouseEvent
import java.util.Random
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.SwingUtilities

class FifteenPuzzle(dim: Int, val margin: Int) : JPanel() {

    private val rand = Random()
    private val tiles = IntArray(16)
    private val tileSize = (dim - 2 * margin) / 4
    private val gridSize = tileSize * 4
    private var blankPos = 0

    init {
        preferredSize = Dimension(dim, dim)
        background = Color.white
        val cornflowerBlue = 0x6495ED
        foreground = Color(cornflowerBlue)
        font = Font("SansSerif", Font.BOLD, 60)

        addMouseListener(object : MouseAdapter() {
            override fun mousePressed(e: MouseEvent) {
                val ex = e.x - margin
                val ey = e.y - margin
                if (ex !in 0..gridSize || ey !in 0..gridSize) return

                val c1 = ex / tileSize
                val r1 = ey / tileSize
                val c2 = blankPos % 4
                val r2 = blankPos / 4
                if ((c1 == c2 && Math.abs(r1 - r2) == 1) ||
                    (r1 == r2 && Math.abs(c1 - c2) == 1)) {
                    val clickPos = r1 * 4 + c1
                    tiles[blankPos] = tiles[clickPos]
                    tiles[clickPos] = 0
                    blankPos = clickPos
                }
                repaint()
            }
        })

        shuffle()
    }

    private fun shuffle() {
        do {
            reset()
            // don't include the blank space in the shuffle,
            // leave it in the home position
            var n = 15
            while (n > 1) {
                val r = rand.nextInt(n--)
                val tmp = tiles[r]
                tiles[r] = tiles[n]
                tiles[n] = tmp
            }
        } while (!isSolvable())
    }

    private fun reset() {
        for (i in 0 until tiles.size) {
            tiles[i] = (i + 1) % tiles.size
        }
        blankPos = 15
    }

    /*  Only half the permutations of the puzzle are solvable.

        Whenever a tile is preceded by a tile with higher value it counts
        as an inversion. In our case, with the blank space in the home
        position, the number of inversions must be even for the puzzle
        to be solvable.
    */

    private fun isSolvable(): Boolean {
        var countInversions = 0
        for (i in 0 until 15) {
            (0 until i)
                .filter { tiles[it] > tiles[i] }
                .forEach { countInversions++ }
        }
        return countInversions % 2 == 0
    }

    private fun drawGrid(g: Graphics2D) {
        for (i in 0 until tiles.size) {
            if (tiles[i] == 0) continue

            val r = i / 4
            val c = i % 4
            val x = margin + c * tileSize
            val y = margin + r * tileSize

            with(g) {
                color = foreground
                fillRoundRect(x, y, tileSize, tileSize, 25, 25)
                color = Color.black
                drawRoundRect(x, y, tileSize, tileSize, 25, 25)
                color = Color.white
            }
            drawCenteredString(g, tiles[i].toString(), x, y)
        }
    }

    private fun drawCenteredString(g: Graphics2D, s: String, x: Int, y: Int) {
        val fm = g.fontMetrics
        val asc = fm.ascent
        val des = fm.descent

        val xx = x + (tileSize - fm.stringWidth(s)) / 2
        val yy = y + (asc + (tileSize - (asc + des)) / 2)

        g.drawString(s, xx, yy)
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
            RenderingHints.VALUE_ANTIALIAS_ON)
        drawGrid(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Fifteen Puzzle"
            isResizable = false
            add(FifteenPuzzle(640, 80), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
