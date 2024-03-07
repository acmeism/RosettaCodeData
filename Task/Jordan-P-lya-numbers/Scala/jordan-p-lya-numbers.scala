import java.util.{ArrayList, HashMap, TreeMap, TreeSet}
import scala.jdk.CollectionConverters._

object JordanPolyaNumbers {

  private val jordanPolyaSet = new TreeSet[Long]()
  private val decompositions = new HashMap[Long, TreeMap[Integer, Integer]]()

  def main(args: Array[String]): Unit = {
    createJordanPolya()

    val belowHundredMillion = jordanPolyaSet.floor(100_000_000L)
    val jordanPolya = new ArrayList[Long](jordanPolyaSet)

    println("The first 50 Jordan-Polya numbers:")
    jordanPolya.asScala.take(50).zipWithIndex.foreach { case (number, index) =>
      print(f"$number%5s${if(index % 10 == 9) "\n" else ""}")
    }
    println()

    println(s"The largest Jordan-Polya number less than 100 million: $belowHundredMillion")
    println()

    List(800, 1050, 1800, 2800, 3800).foreach { i =>
      println(s"The ${i}th Jordan-Polya number is: ${jordanPolya.get(i - 1)} = ${toString(decompositions.get(jordanPolya.get(i - 1)))}")
    }
  }

  private def createJordanPolya(): Unit = {
    jordanPolyaSet.add(1L)
    val nextSet = new TreeSet[Long]()
    decompositions.put(1L, new TreeMap[Integer, Integer]())
    var factorial = 1L

    for (multiplier <- 2 to 20) {
      factorial *= multiplier
      val it = jordanPolyaSet.iterator()
      while (it.hasNext) {
        var number = it.next()
        while (number <= Long.MaxValue / factorial) {
          val original = number
          number *= factorial
          nextSet.add(number)
          decompositions.put(number, new TreeMap[Integer, Integer](decompositions.get(original)))
          val currentMap = decompositions.get(number)
          currentMap.merge(multiplier, 1, (a: Integer, b: Integer) => Integer.sum(a, b))
        }
      }
      jordanPolyaSet.addAll(nextSet)
      nextSet.clear()
    }
  }

  private def toString(aMap: TreeMap[Integer, Integer]): String = {
    aMap.descendingMap().asScala.map { case (key, value) =>
      s"$key!${if (value == 1) "" else "^" + value}"
    }.mkString(" * ")
  }
}
