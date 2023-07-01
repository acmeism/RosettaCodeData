object GroupStage extends App { //team left digit vs team right digit
  val games = Array("12", "13", "14", "23", "24", "34")
  val points = Array.ofDim[Int](4, 10) //playing 3 games, points range from 0 to 9
  var results = "000000" //start with left teams all losing

  private def nextResult: Boolean = {
    if (results == "222222") false
    else {
      results = Integer.toString(Integer.parseInt(results, 3) + 1, 3)
      while (results.length < 6) results = "0" + results //left pad with 0s
      true
    }
  }

  do {
    val records = Array(0, 0, 0, 0)
    for (i <- results.indices.reverse by -1) {
      results(i) match {
        case '2' => records(games(i)(0) - '1') += 3
        case '1' => //draw
          records(games(i)(0) - '1') += 1
          records(games(i)(1) - '1') += 1
        case '0' => records(games(i)(1) - '1') += 3
      }
    }
    java.util.Arrays.sort(records) //sort ascending, first place team on the right

    points(0)(records(0)) += 1
    points(1)(records(1)) += 1
    points(2)(records(2)) += 1
    points(3)(records(3)) += 1
  } while (nextResult)

  println("First place: " + points(3).mkString("[",", ","]"))
  println("Second place: " + points(2).mkString("[",", ","]"))
  println("Third place: " + points(1).mkString("[",", ","]"))
  println("Fourth place: " + points(0).mkString("[",", ","]"))

}
