import java.util.Random

import jline.console._

import scala.annotation.tailrec
import scala.collection.immutable
import scala.collection.parallel.immutable.ParVector

object FifteenPuzzle {
  def main(args: Array[String]): Unit = play()

  @tailrec def play(len: Int = 1000): Unit = if(gameLoop(Board.randState(len))) play(len)
  def gameLoop(board: Board): Boolean = {
    val read = new ConsoleReader()
    val km = KeyMap.keyMaps().get("vi-insert")
    val opMap = immutable.HashMap[Operation, Char](
      Operation.PREVIOUS_HISTORY -> 'u',
      Operation.BACKWARD_CHAR -> 'l',
      Operation.NEXT_HISTORY -> 'd',
      Operation.FORWARD_CHAR -> 'r')

    @tailrec
    def gloop(b: Board): Boolean = {
      println(s"\u001B[2J\u001B[2;0H$b\n←↑→↓q")
      if(b.isSolved) println("Solved!\nPlay again? (y/n)")

      read.readBinding(km) match{
        case Operation.SELF_INSERT => read.getLastBinding match{
          case "q" => false
          case "y" if b.isSolved => true
          case "n" if b.isSolved => false
          case _ => gloop(b)
        }
        case op: Operation if opMap.isDefinedAt(op) => gloop(b.move(opMap(op)))
        case _ => gloop(b)
      }
    }

    gloop(board)
  }

  case class Board(mat: immutable.HashMap[(Int, Int), Int], x: Int, y: Int) {
    def move(mvs: Seq[Char]): Board = mvs.foldLeft(this){case (b, m) => b.move(m)}
    def move(mov: Char): Board = mov match {
      case 'r' if x < 3 => Board(mat ++ Seq(((x, y), mat((x + 1, y))), ((x + 1, y), 0)), x + 1, y)
      case 'l' if x > 0 => Board(mat ++ Seq(((x, y), mat((x - 1, y))), ((x - 1, y), 0)), x - 1, y)
      case 'd' if y < 3 => Board(mat ++ Seq(((x, y), mat((x, y + 1))), ((x, y + 1), 0)), x, y + 1)
      case 'u' if y > 0 => Board(mat ++ Seq(((x, y), mat((x, y - 1))), ((x, y - 1), 0)), x, y - 1)
      case _ => this
    }

    def isSolved: Boolean = sumDist == 0
    def sumDist: Int = mat.to(LazyList).map{ case ((a, b), n) => if(n == 0) 6 - a - b else (a + b - ((n - 1) % 4) - ((n - 1) / 4)).abs }.sum

    override def toString: String = {
      val lst = mat.toVector.map { case ((a, b), n) => (4 * b + a, n) }.sortWith(_._1 < _._1).map(_._2)
      lst.map { n => if (n == 0) "  " else f"$n%2d" }.grouped(4).map(_.mkString(" ")).mkString("\n")
    }
  }

  object Board {
    val moves: Vector[Char] = Vector('r', 'l', 'd', 'u')

    def apply(config: Vector[Int]): Board = {
      val ind = config.indexOf(0)
      val formed = config.zipWithIndex.map { case (n, i) => ((i % 4, i / 4), n) }
      val builder = immutable.HashMap.newBuilder[(Int, Int), Int]
      builder ++= formed
      Board(builder.result, ind % 4, ind / 4)
    }

    def solveState: Board = apply((1 to 15).toVector :+ 0)
    def randState(len: Int, rand: Random = new Random()): Board = Iterator
      .fill(len)(moves(rand.nextInt(4)))
      .foldLeft(Board.solveState) { case (state, mv) => state.move(mv) }
  }
}
