import scala.collection.mutable.ListBuffer
import scala.util.Random

object BalancedBrackets extends App {

  val random = new Random()
  def generateRandom: List[String] = {
    import scala.util.Random._
    val shuffleIt: Int => String = i => shuffle(("["*i+"]"*i).toList).foldLeft("")(_+_)
    (1 to 20).map(i=>(random.nextDouble*100).toInt).filter(_>2).map(shuffleIt(_)).toList
  }

  def generate(n: Int): List[String] = {
    val base = "["*n+"]"*n
    var lb = ListBuffer[String]()
    base.permutations.foreach(s=>lb+=s)
    lb.toList.sorted
  }

  def checkBalance(brackets: String):Boolean = {
    def balI(brackets: String, depth: Int):Boolean = {
      if (brackets == "") depth == 0
      else brackets(0) match {
        case '[' => ((brackets.size > 1) && balI(brackets.substring(1), depth + 1))
        case ']' => (depth > 0) && ((brackets.size == 1) || balI(brackets.substring(1), depth -1))
        case _   => false
      }
    }
    balI(brackets, 0)
  }

  println("arbitrary random order:")
  generateRandom.map(s=>Pair(s,checkBalance(s))).foreach(p=>println((if(p._2) "balanced:   " else "unbalanced: ")+p._1))
  println("\n"+"check all permutations of given length:")
  (1 to 5).map(generate(_)).flatten.map(s=>Pair(s,checkBalance(s))).foreach(p=>println((if(p._2) "balanced:   " else "unbalanced: ")+p._1))
}
