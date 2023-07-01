import scala.util.Random
Random.setSeed(1)

def rollDice():Int = {
  val v4 = Stream.continually(Random.nextInt(6)+1).take(4)
  v4.sum - v4.min
}

def getAttributes():Seq[Int] = Stream.continually(rollDice()).take(6)

def getCharacter():Seq[Int] = {
  val attrs = getAttributes()
  println("generated => " + attrs.mkString("[",",", "]"))
  (attrs.sum, attrs.filter(_>15).size) match {
    case (a, b)  if (a < 75 || b < 2) => getCharacter
    case _ => attrs
  }
}

println("picked => " + getCharacter.mkString("[", ",", "]"))
