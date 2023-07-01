object RockPaperScissors extends App {
    def beats = Map(
        'rock -> Set('lizard, 'scissors),
        'paper -> Set('rock, 'spock),
        'scissors -> Set('paper, 'lizard),
        'lizard -> Set('spock, 'paper),
        'spock -> Set('scissors, 'rock)
    )
    // init with uniform probabilities
    def initPlayed = beats.mapValues(_ => 1)
    def input = Symbol(readLine(s"""Your move (${beats.keys mkString ", "}): """))
    def random(max: Int) = scala.util.Random.nextInt(max)
    def display(text: String) = print(text)

    def weighted(todo: Iterator[(Symbol,Int)], rand: Int, accum: Int = 0): Symbol = todo.next match {
        case (s, i) if rand <= (accum + i) => s
        case (_, i) => weighted(todo, rand, accum + i)
    }

    def calcMyMove(random: Int => Int, played: Map[Symbol,Int]) = {
        weighted(played.toIterator, 1 + random(played.values.sum)) match {
        // choose an opponent that would beat the player's anticipated move
            case h => beats.find{case (s, l) => l contains h}.getOrElse(beats.head)._1
        }
    }

    case class Result(text: String, won: Int, lost: Int, drew: Int) {
        override def toString = s"$text. Won: $won, Lost: $lost, Drew: $drew"
    }

    def getResult(userWeapon: Symbol, myMove: Symbol, result: Result) = {
        if (beats(userWeapon) contains myMove)
            result.copy(text = "You won", won = result.won + 1)
        else if (beats(myMove) contains userWeapon)
            result.copy(text = "You lost", lost = result.lost + 1)
        else result.copy(text = "We drew", drew = result.drew + 1)
     }

    def play(input: => Symbol, display: String => Unit, random: Int => Int)
        (played: Map[Symbol,Int], result: Result): Result = {
        val userWeapon = input
        if (userWeapon != Symbol("")) {
            val newResult = if (beats contains userWeapon) {
                val myMove = calcMyMove(random, played)
                display(s"  My move: $myMove\n  ")
                getResult(userWeapon, myMove, result)
            } else {
                result.copy(text = "  Unknown weapon, try again")
            }
            display(newResult + "\n")
            play(input, display, random)(played get userWeapon match {
                case None => played
                case Some(count) => played.updated(userWeapon, count + 1)
            }, newResult)
        } else result
    }

    override def main(args: Array[String]): Unit =
        play(input, display, random)(initPlayed, Result("Start", 0, 0, 0))
}
