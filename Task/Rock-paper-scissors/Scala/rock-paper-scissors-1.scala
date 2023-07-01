object RockPaperScissors extends App {
  import scala.collection.mutable.LinkedHashMap
  def play(beats: LinkedHashMap[Symbol,Set[Symbol]], played: scala.collection.Map[Symbol,Int]) {
    val h = readLine(s"""Your move (${beats.keys mkString ", "}): """) match {
      case null => println; return
      case "" => return
      case s => Symbol(s)
    }
    beats get h match {
      case Some(losers) =>
        def weighted(todo: Iterator[(Symbol,Int)], rand: Int, accum: Int = 0): Symbol = todo.next match {
          case (s, i) if rand <= (accum + i) => s
          case (_, i) => weighted(todo, rand, accum + i)
        }
        val c = weighted(played.toIterator, 1 + scala.util.Random.nextInt(played.values.sum)) match {
          // choose an opponent that would beat the player's anticipated move
          case h => beats.find{case (s, l) => l contains h}.getOrElse(beats.head)._1
        }
        print(s"  My move: $c\n  ")
        c match {
          case c if losers contains c => println("You won")
          case c if beats(c) contains h => println("You lost")
          case _ => println("We drew") // or underspecified
        }
      case x => println("  Unknown weapon, try again.")
    }
    play(beats, played get h match {
      case None => played
      case Some(count) => played.updated(h, count + 1)
    })
  }

  def play(beats: LinkedHashMap[Symbol,Set[Symbol]]): Unit =
      play(beats, beats.mapValues(_ => 1)) // init with uniform probabilities

  play(LinkedHashMap(
    'rock -> Set('lizard, 'scissors),
    'paper -> Set('rock, 'spock),
    'scissors -> Set('paper, 'lizard),
    'lizard -> Set('spock, 'paper),
    'spock -> Set('scissors, 'rock)
  ))
}
