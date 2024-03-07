import scala.collection.mutable.ListBuffer

object DeBruijn {

  def deBruijn(k: Int, n: Int): String = {
    val a = Array.fill[Byte](k * n)(0)
    val seq = new ListBuffer[Byte]()

    def db(t: Int, p: Int): Unit = {
      if (t > n) {
        if (n % p == 0) {
          seq ++= a.slice(1, p + 1)
        }
      } else {
        a(t) = a(t - p)
        db(t + 1, p)
        for (j <- (a(t - p) + 1).until(k)) {
          a(t) = j.toByte
          db(t + 1, t)
        }
      }
    }

    db(1, 1)

    val sb = new StringBuilder
    seq.foreach(i => sb.append("0123456789".charAt(i)))
    sb.append(sb.subSequence(0, n - 1)).toString
  }

  private def allDigits(s: String): Boolean = s.forall(_.isDigit)

  private def validate(db: String): Unit = {
    val found = Array.fill(10000)(0)
    val errs = ListBuffer[String]()

    for (i <- 0 until db.length - 3) {
      val s = db.substring(i, i + 4)
      if (allDigits(s)) {
        val n = s.toInt
        found(n) += 1
      }
    }

    for (i <- found.indices) {
      if (found(i) == 0) errs += s"    PIN number $i is missing"
      else if (found(i) > 1) errs += s"    PIN number $i occurs ${found(i)} times"
    }

    if (errs.isEmpty) println("    No errors found")
    else {
      val pl = if (errs.size == 1) "" else "s"
      println(s"  ${errs.size} error$pl found:")
      errs.foreach(println)
    }
  }

  def main(args: Array[String]): Unit = {
    val db = deBruijn(10, 4)

    println(s"The length of the de Bruijn sequence is ${db.length}\n")
    println(s"The first 130 digits of the de Bruijn sequence are: ${db.take(130)}\n")
    println(s"The last 130 digits of the de Bruijn sequence are: ${db.takeRight(130)}\n")

    println("Validating the de Bruijn sequence:")
    validate(db)

    println()
    println("Validating the reversed de Bruijn sequence:")
    validate(db.reverse)

    val overlaidDb = db.updated(4443, '.')
    println()
    println("Validating the overlaid de Bruijn sequence:")
    validate(overlaidDb)
  }
}
