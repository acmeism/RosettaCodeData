object Game21 {

  import scala.collection.mutable.ListBuffer
  import scala.util.Random

  val N = 21 // the same game would also work for N other than 21...

  val RND = new Random() // singular random number generator; add a seed number, if you want reproducibility

  /** tuple: name and a play function: (rest: remaining number, last: value of opponent's last move) => new move
    */
  type Player = (String, (Int,Int) => Int)

  // indeed, the following could also be written using a class and instances, I've choosen a
  // more functional and math way (using tuples)...
  val playerRandom:Player = ("RandomRobot", { (rest, last) =>
    if (rest <= 3) rest
    else 1 + RND.nextInt(3)
  })
  val playerBest:Player = ("BestRobot", { (rest, last) =>
    val i = rest % 4
    if (i > 0) i else 1 + RND.nextInt(3)
  })
  val playerHuman:Player = ("YOU", { (rest, last) =>
    println("Rest: "+rest)
    println("Last: "+last)
    var in = ""
    while (in!="1" && in!="2" && in!="3") {
      in = scala.io.StdIn.readLine("Your move (1,2,3,q)> ").trim
      if ("q" == in)
        throw new Exception("q => quit")
    }
    in.toInt
  })

  /** Execute a whole game. NOTE that we're counting DOWN from N to 0!
    * @param players
    * @return list of all moves
    */
  def play(players:Seq[Player]):Seq[Int] = {
    require(players.size == 2)
    var last = -1
    var rest = N
    var p = 0 // player 0 always starts
    val l = ListBuffer[Int]() // list of all moves
    while (rest > 0) {
      last = players(p)._2(rest,last)
      require(1<=last && last<=3,"Player must always play 1,2,3: "+last)
      l += last
      rest -= last
      p = 1 - p // other player's turn
    }
    l.toSeq
  }

  /** Evaluate a whole game.
    * @param game list of moves of one game
    * @param rest mainly for recursion
    * @return evaluation, for each move a tuple: (rest, what was played, whether this player won in the end)
    */
  def evaluate(game:Seq[Int],rest:Int=N):Seq[(Int,Int,Boolean)] = {
    if (game.size == 0) Seq()
    else Seq((rest,game.head,game.size%2 == 1)) ++ evaluate(game.tail,rest - game.head)
  }

  def main(args: Array[String]): Unit = {
    // here you can put whatever player combination you like
    val players = Seq(playerRandom,playerRandom) // random robot vs random robot
    //val players = Seq(playerRandom,playerBest) // random robot vs best robot
    //val players = Seq(playerHuman,playerBest) // You vs best robot
    var p0won = 0
    val n = 1000 // number of games to play
    var m = 0 // games actually played (a human player might quit before n)
    try {
      (1 to n).foreach { i =>
        val g = play(players)
        require(g.sum == N) // some validity checks
        val e = evaluate(g)
        require(e.size == g.size && e.last._3 && e(0)._3 != e(1)._3) // some validity checks
        if (e(0)._3) p0won += 1
        m += 1
        println(i + ": " + players(0)._1 + " " + (if (e(0)._3) "won" else "lost") + " against " + players(1)._1 + ". " + g + " => " + e)
      }
    } catch {
      case t:Throwable => println(t.getMessage)
    }
    println("Player0: "+players(0)._1)
    println("Player1: "+players(1)._1)
    println(f"Player0 won ${p0won} times out of ${m}, or ${p0won * 100.0 / m}%%")
  }
}
