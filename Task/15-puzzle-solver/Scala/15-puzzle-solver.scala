import scala.collection.mutable
case class Board(table: Array[Int], r: Int, c: Int, parent: List[String] = List()) {
  def cloneSwap(r: Int, c: Int, rr: Int, cc: Int) = {
    val cTable = table.clone
    // Fancy way to access table(r)(c) in linear array
    // Equivalent with cTable(r*4 + c)
    cTable(r << 2 | c) = table(rr << 2 | cc)
    cTable(rr << 2 | cc) = table(r << 2 | c)
    cTable
  }
  def up() =
    if (r > 0) { Some(Board(cloneSwap(r, c, r - 1, c), r - 1, c, "u" :: parent))
    } else None
  def down() =
    if (r < 3) { Some(Board(cloneSwap(r, c, r + 1, c), r + 1, c, "d" :: parent))
    } else None
  def left() =
    if (c > 0) { Some(Board(cloneSwap(r, c, r, c - 1), r, c - 1, "l" :: parent))
    } else None
  def right() =
    if (c < 3) { Some(Board(cloneSwap(r, c, r, c + 1), r, c + 1, "r" :: parent))
    } else None
  def format: String = {
    table.sliding(4, 4).toList.map(_.map(i ⇒ f"$i%4d").mkString).mkString("\n")
  }
  // Manhattan distance
  def heuristic() = {
    val posF = Board.finalBoard.positionMap
    val posT = positionMap
    var res = 0;
    for (i ← 0 to 15) {
      val (x, y) = posF(i)
      val (xx, yy) = posT(i)
      res += (Math.abs(x - xx) + Math.abs(y - yy))
    }
    res
  }
  def key = table.mkString(",")
  def travelled() = parent.length
  // Find children/neighbours, flatten eliminates the empty boundaries
  def children: List[Board] = List(this.up(), this.down(), this.right(), this.left()).flatten
  // Map number to positions
  lazy val positionMap: Map[Int, (Int, Int)] = {
    val res = mutable.Map[Int, (Int, Int)]()
    for (x ← 0 to 3; y ← 0 to 3) {
      res(table(x << 2 | y)) = (x, y)
    }
    res.toMap
  }
}

import Board._
object Solver extends App {
  def solve(initBoard: Board, wTravel:Int, wHeuristic: Int ) {
    // Setup weights for the heuristic, more weight to heuristic faster but longer solution.
    def aStar(b:  Board) = wHeuristic * b.heuristic() + wTravel * b.travelled()
    implicit val ob = new Ordering[Board] {
      override def compare(x: Board, y: Board) = {
        aStar(y) - aStar(x)
      }
    }
    val start = System.currentTimeMillis()
    var found = false
    var head = initBoard
    val pq: mutable.PriorityQueue[Board] = new mutable.PriorityQueue()
    pq.enqueue(head)
    val visited = mutable.HashSet[String]()
    var explore = 0
    while (pq.nonEmpty && !found) {
      head = pq.dequeue()
      visited.add(head.key)
      if (!head.key.equals(finalBoard.key)) {
        val newChildren = head.children.filter(child ⇒ !visited.contains(child.key))
        visited ++= (newChildren.map(_.key))
        pq.enqueue(newChildren: _*)
        explore += 1
      } else found = true
      if (explore % 5000 == 0)
        println(s"# $explore: A* ${aStar(head)}  g:${head.travelled()} h:${head.heuristic()}")
    }
    if (found) {
      println(s"Exploring $explore states, solution with length ${head.parent.length}.")
      println(s"Weighted heuristic used $wHeuristic * heuristic + $wTravel * travel.")
      println(initBoard.format)
      println(head.parent.mkString.reverse)
    }
    println("Total time: " + (System.currentTimeMillis() - start) / 1000.0 + " seconds")
  }
  solve(startEasy, 4, 5)
  solve(startHard, 1, 2 )
}

object Board {
  val finalBoard = Board(Array(Array(1, 2, 3, 4), Array(5, 6, 7, 8), Array(9, 10, 11, 12), Array(13, 14, 15, 0)).flatten, 3, 3)
  val startEasy = Board(Array(Array(15, 14, 1, 6), Array(9, 11, 4, 12), Array(0, 10, 7, 3), Array(13, 8, 5, 2)).flatten, 2, 0)
  val startHard = Board(Array(Array(0, 12, 9, 13), Array(15, 11, 10, 14), Array(3, 7, 2, 5), Array(4, 8, 6, 1)).flatten, 0, 0)
}
