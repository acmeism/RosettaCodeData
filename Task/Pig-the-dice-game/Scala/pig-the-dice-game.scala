object PigDice extends App {
  private val (maxScore, nPlayers) = (100, 2)
  private val rnd = util.Random

  private case class Game(gameOver: Boolean, idPlayer: Int, score: Int, stickedScores: Vector[Int])

  @scala.annotation.tailrec
  private def loop(play: Game): Unit =
    play match {
      case Game(true, _, _, _) =>
      case Game(false, gPlayer, gScore, gStickedVals) =>
        val safe = gStickedVals(gPlayer)
        val stickScore = safe + gScore
        val gameOver = stickScore >= maxScore

        def nextPlayer = (gPlayer + 1) % nPlayers

        def gamble: Game = play match {
          case Game(_: Boolean, lPlayer: Int, lScore: Int, lStickedVals: Vector[Int]) =>
            val rolled: Int = rnd.nextInt(6) + 1

            println(s" Rolled $rolled")
            if (rolled == 1) {
              println(s" Bust! You lose $lScore but keep ${lStickedVals(lPlayer)}\n")
              play.copy(idPlayer = nextPlayer, score = 0)
            } else play.copy(score = lScore + rolled)
        }

        def stand: Game = play match {
          case Game(_, lPlayer, _, lStickedVals) =>

            println(
              (if (gameOver) s"\n\nPlayer $lPlayer wins with a score of" else " Sticking with")
                + s" $stickScore.\n")

            Game(gameOver, nextPlayer, 0, lStickedVals.updated(lPlayer, stickScore))
        }

        if (!gameOver && Seq("y", "").contains(
            io.StdIn.readLine(f" Player $gPlayer%d: ($safe%d, $gScore%d) Rolling? ([y]/n): ").toLowerCase)
        ) loop(gamble )else loop(stand)
    }

  loop(Game(gameOver = false, 0, 0, Array.ofDim[Int](nPlayers).toVector))
}
