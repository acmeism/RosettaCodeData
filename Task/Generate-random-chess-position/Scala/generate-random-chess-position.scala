import scala.math.abs
import scala.util.Random

object RandomFen extends App {
  val rand = new Random

  private def createFen = {
    val grid = Array.ofDim[Char](8, 8)

    def placeKings(grid: Array[Array[Char]]): Unit = {
      var r1, c1, r2, c2 = 0
      do {
        r1 = rand.nextInt(8)
        c1 = rand.nextInt(8)
        r2 = rand.nextInt(8)
        c2 = rand.nextInt(8)
      } while (r1 == r2 || abs(r1 - r2) <= 1 || abs(c1 - c2) <= 1)
      grid(r1)(c1) = 'K'
      grid(r2)(c2) = 'k'
    }

    def placePieces(grid: Array[Array[Char]],
                    pieces: String,
                    isPawn: Boolean): Unit = {
      val numToPlace = rand.nextInt(pieces.length)

      for (n <- 0 until numToPlace) {
        var r, c = 0
        do {
          r = rand.nextInt(8)
          c = rand.nextInt(8)
        } while (grid(r)(c) != 0 || (isPawn && (r == 7 || r == 0)))
        grid(r)(c) = pieces(n)
      }
    }

    def toFen(grid: Array[Array[Char]]) = {
      val fen = new StringBuilder
      var countEmpty = 0
      for (r <- grid.indices) {
        for (c <- grid.indices) {
          val ch = grid(r)(c)
          print(f"${if (ch == 0) '.' else ch}%2c ")
          if (ch == 0) countEmpty += 1
          else {
            if (countEmpty > 0) {
              fen.append(countEmpty)
              countEmpty = 0
            }
            fen.append(ch)
          }
        }
        if (countEmpty > 0) {
          fen.append(countEmpty)
          countEmpty = 0
        }
        fen.append("/")
        println()
      }
      fen.append(" w - - 0 1").toString
    }

    placeKings(grid)
    placePieces(grid, "PPPPPPPP", isPawn = true)
    placePieces(grid, "pppppppp", isPawn = true)
    placePieces(grid, "RNBQBNR", isPawn = false)
    placePieces(grid, "rnbqbnr", isPawn = false)
    toFen(grid)
  }

  println(createFen)

}
