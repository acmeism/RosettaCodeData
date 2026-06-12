object RoundRobinTournamentSchedule extends App {

  def roundRobin(teamCount: Int): Unit = {
    require(teamCount >= 2, s"Number of teams must be greater than 2: $teamCount")

    var rotatingList = (2 to teamCount).toList
    var adjustedTeamCount = teamCount

    if (teamCount % 2 == 1) {
      rotatingList :+= 0
      adjustedTeamCount += 1
    }

    for (round <- 1 until adjustedTeamCount) {
      print(f"Round $round%2d:")
      val fixedList = 1 :: rotatingList
      for (i <- 0 until adjustedTeamCount / 2) {
        print(f" ( ${fixedList(i)}%2d vs ${fixedList(adjustedTeamCount - 1 - i)}%2d )")
      }
      println()
      rotatingList = rotatingList.last :: rotatingList.init
    }
  }

  println("Round robin for 12 players:")
  roundRobin(12)
  println()
  println("Round robin for 5 players, 0 denotes a bye:")
  roundRobin(5)
}
