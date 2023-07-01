object PythagoreanQuadruple extends App {
  val MAX = 2200
  val MAX2: Int = MAX * MAX * 2
  val found = Array.ofDim[Boolean](MAX + 1)
  val a2b2 = Array.ofDim[Boolean](MAX2 + 1)
  var s = 3
  for (a <- 1 to MAX) {
    val a2 = a * a

    for (b <- a to MAX) a2b2(a2 + b * b) = true
  }

  for (c <- 1 to MAX) {
    var s1 = s
    s += 2
    var s2 = s
    for (d <- (c + 1) to MAX) {
      if (a2b2(s1)) found(d) = true
      s1 += s2
      s2 += 2
    }
  }

  println(f"The values of d <= ${MAX}%d which can't be represented:")
  val notRepresented = (1 to MAX).filterNot(d =>  found(d) )
  println(notRepresented.mkString(" "))

}
