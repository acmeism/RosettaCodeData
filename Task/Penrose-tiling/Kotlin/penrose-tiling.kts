// version 1.1.2

import java.awt.*
import java.awt.geom.Path2D
import javax.swing.*

class PenroseTiling(w: Int, h: Int) : JPanel() {
    private enum class Type {
        KITE, DART
    }

    private class Tile(
        val type: Type,
        val x: Double,
        val y: Double,
        val angle: Double,
        val size: Double
    ) {
        override fun equals(other: Any?): Boolean {
            if (other == null || other !is Tile) return false
            return type == other.type && x == other.x && y == other.y &&
                   angle == other.angle && size == other.size
        }
    }

    private companion object {
        val G = (1.0 + Math.sqrt(5.0)) / 2.0  // golden ratio
        val T = Math.toRadians(36.0)          // theta
    }

    private val tiles: List<Tile>

    init {
        preferredSize = Dimension(w, h)
        background = Color.white
        tiles = deflateTiles(setupPrototiles(w, h), 5)
    }

    private fun setupPrototiles(w: Int, h: Int): List<Tile> {
        val proto = mutableListOf<Tile>()
        var a = Math.PI / 2.0 + T
        while (a < 3.0 * Math.PI) {
            proto.add(Tile(Type.KITE, w / 2.0, h / 2.0, a, w / 2.5))
            a += 2.0 * T
        }
        return proto
    }

    private fun deflateTiles(tls: List<Tile>, generation: Int): List<Tile> {
        if (generation <= 0) return tls
        val next = mutableListOf<Tile>()

        for (tile in tls) {
            val x = tile.x
            val y = tile.y
            val a = tile.angle
            var nx: Double
            var ny: Double
            val size = tile.size / G

            if (tile.type == Type.DART) {
                next.add(Tile(Type.KITE, x, y, a + 5.0 * T, size))
                var sign = 1
                for (i in 0..1) {
                    nx = x + Math.cos(a - 4.0 * T * sign) * G * tile.size
                    ny = y - Math.sin(a - 4.0 * T * sign) * G * tile.size
                    next.add(Tile(Type.DART, nx, ny, a - 4.0 * T * sign, size))
                    sign *= -1
                }
            }
            else {
                var sign = 1
                for (i in 0..1) {
                    next.add(Tile(Type.DART, x, y, a - 4.0 * T * sign, size))
                    nx = x + Math.cos(a - T * sign) * G * tile.size
                    ny = y - Math.sin(a - T * sign) * G * tile.size
                    next.add(Tile(Type.KITE, nx, ny, a + 3.0 * T * sign, size))
                    sign *= -1
                }
            }
        }
        // remove duplicates and deflate
        return deflateTiles(next.distinct(), generation - 1)
    }

    private fun drawTiles(g: Graphics2D) {
        val dist = arrayOf(
            doubleArrayOf(G, G, G),
            doubleArrayOf(-G, -1.0, -G)
        )
        for (tile in tiles) {
            var angle = tile.angle - T
            val path = Path2D.Double()
            path.moveTo(tile.x, tile.y)
            val ord = tile.type.ordinal
            for (i in 0..2) {
                val x = tile.x + dist[ord][i] * tile.size * Math.cos(angle)
                val y = tile.y - dist[ord][i] * tile.size * Math.sin(angle)
                path.lineTo(x, y)
                angle += T
            }
            path.closePath()
            with(g) {
                color = if (ord == 0) Color.pink else Color.red
                fill(path)
                color = Color.darkGray
                draw(path)
            }
        }
    }

    override fun paintComponent(og: Graphics) {
        super.paintComponent(og)
        val g = og as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        drawTiles(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with (f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Penrose Tiling"
            isResizable = false
            add(PenroseTiling(700, 450), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
