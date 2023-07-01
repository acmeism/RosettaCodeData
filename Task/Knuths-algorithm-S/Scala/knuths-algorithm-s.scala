import java.util
import scala.util.Random

object KnuthsAlgorithmS extends App {

  import scala.collection.JavaConverters._

  val (n, rand, bin) = (3, Random, new Array[Int](10))

  for (_ <- 0 until 100000) {
    val sample = new util.ArrayList[Int](n)
    for (item <- 0 until 10) {
      if (item < n) sample.add(item)
      else if (rand.nextInt(item + 1) < n)
        sample.asScala(rand.nextInt(n)) = item
    }
    for (s <- sample.asScala.toList) bin(s) += 1
  }

  println(bin.mkString("[", ", ", "]"))
}
