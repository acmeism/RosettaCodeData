import java.awt.{BorderLayout, Color, Dimension, Graphics, Graphics2D, RenderingHints}
import java.awt.geom.Path2D

import javax.swing.{JFrame, JPanel}

import scala.math._

object PenroseTiling extends App {
  private val (φ, ϑ) = ((1 + sqrt(5)) / 2, toRadians(36)) // golden ratio and 36 degrees
  private val dist: Array[Array[Double]] = Array(Array(φ, φ, φ), Array(-φ, -1, -φ))

  class PenroseTiling extends JPanel {
    private val (w, h) = (700, 450)
    private val tiles: Set[Tile] = deflateTiles(setupPrototiles(w, h), 5)

    override def paintComponent(og: Graphics): Unit = {
      def drawTiles(g: Graphics2D): Unit =
        for (tile <- tiles) {
          val path: Path2D = new Path2D.Double()
          val distL = dist(tile.tileType.id)

          path.moveTo(tile.x, tile.y)
          for {i <- 0 until 3
               ω = tile.α + (i - 1) * ϑ}
            path.lineTo(
              tile.x + distL(i) * tile.size * cos(ω),
              tile.y - distL(i) * tile.size * sin(ω))

          path.closePath()
          g.setColor(if (tile.tileType == Type.Kite) Color.orange else Color.yellow)
          g.fill(path)
          g.setColor(Color.darkGray)
          g.draw(path)
        }

      super.paintComponent(og)
      val g: Graphics2D = og.asInstanceOf[Graphics2D]
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
      drawTiles(g)
    }

    private def setupPrototiles(w: Int, h: Int): Set[Tile] = (0 to 5).map(n =>
      Tile(Type.Kite, (w / 2).toDouble, (h / 2).toDouble, Pi / 2 + ϑ + n * 2 * ϑ, w / 2.5)).toSet

    @scala.annotation.tailrec
    private def deflateTiles(tls: Set[Tile], generation: Int): Set[Tile] =
      if (generation > 0) {
        val next = for {
          tile <- tls
          size = tile.size / φ
        } yield {

          def nx(factor: Int) = tile.x + cos(tile.α - factor * ϑ) * φ * tile.size
          def ny(factor: Int) = tile.y - sin(tile.α - factor * ϑ) * φ * tile.size

          tile.tileType match {
            case Type.Dart =>
              Seq(Tile(Type.Kite, tile.x, tile.y, tile.α + 5 * ϑ, size)) ++
                (for (sign <- -1 to 1 by 2)
                  yield Tile(Type.Dart, nx(sign * 4), ny(sign * 4), tile.α - 4 * ϑ * sign, size))

            case Type.Kite => (for (sign <- 1 to -1 by -2) yield {
              Seq(Tile(Type.Dart, tile.x, tile.y, tile.α - 4 * ϑ * sign, size),
                Tile(Type.Kite, nx(sign), ny(sign), tile.α + 3 * ϑ * sign, size))
            }).flatten
          }
        }
        deflateTiles(next.flatten, generation - 1)
      } else tls

    private case class Tile(tileType: Type.Type, x: Double, y: Double, α: Double, size: Double)

    private object Type extends Enumeration {
      type Type = Value
      val Kite, Dart = Value
    }

    setPreferredSize(new Dimension(w, h))
    setBackground(Color.white)
  }

  new JFrame("Penrose Tiling") {
    add(new PenroseTiling(), BorderLayout.CENTER)
    pack()
    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    setLocationRelativeTo(null)
    setResizable(false)
    setVisible(true)
  }

}
