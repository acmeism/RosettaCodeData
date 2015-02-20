object Semiprime extends App {

  def isSP(n: Int): Boolean = {
    var nf: Int = 0
    var l = n
    for (i <- 2 to l/2) {
      while (l % i == 0) {
        if (nf == 2) return false
        nf +=1
        l /= i
      }
    }
    nf == 2
  }

  (2 to 100) filter {isSP(_) == true} foreach {i => print("%d ".format(i))}
  println
  1675 to 1681 foreach {i => println(i+" -> "+isSP(i))}

}
