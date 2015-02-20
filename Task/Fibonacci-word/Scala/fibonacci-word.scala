//word iterator
def fibIt = Iterator.iterate(("1","0")){case (f1,f2) => (f2,f1+f2)}.map(_._1)

//entropy calculator
def entropy(src: String): Double = {
  val xs = src.groupBy(identity).map(_._2.length)
  var result = 0.0
  xs.foreach{c =>
    val p = c.toDouble / src.length
    result -= p * (Math.log(p) / Math.log(2))
  }
  result
}

//printing (spaces inserted to get the tabs align properly)
val it = fibIt.zipWithIndex.map(w => (w._2, w._1.length, entropy(w._1)))
println(it.take(37).map{case (n,l,e) => s"$n).\t$l       \t$e"}.mkString("\n"))
