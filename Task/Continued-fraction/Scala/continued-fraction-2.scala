object CFI extends App {
  import Stream._
  val sqrt2 = 1 #:: from(2,0) zip from(1,0)
  val napier = 2 #:: from(1) zip (1 #:: from(1))
  val pi = 3 #:: from(6,0) zip (from(1,2) map {x=>x*x})

  // reference values, source: wikipedia
  val refPi     = "3.14159265358979323846264338327950288419716939937510"
  val refNapier = "2.71828182845904523536028747135266249775724709369995"
  val refSQRT2  = "1.41421356237309504880168872420969807856967187537694"

  def calc_i(cf: Stream[(Int, Int)], numberOfIters: Int=50): BigDecimal = {
    val cfl = cf take numberOfIters toList
    var z: BigDecimal = 1.0
    for (i <- 0 to cfl.size-1 reverse)
      z=cfl(i)._1+cfl(i)._2/z
    z
  }

  def approx(cfV: BigDecimal, cfRefV: String): String = {
    val p: Pair[Char,Char] => Boolean = pair =>(pair._1==pair._2)
    ((cfV.toString+" "*34).substring(0,34) zip cfRefV.toString.substring(0,34))
      .takeWhile(p).foldRight[String]("")((a:Pair[Char,Char],z)=>a._1+z)
  }

  List(("sqrt2",sqrt2,50,refSQRT2),("napier",napier,50,refNapier),("pi",pi,50000,refPi)) foreach {t=>
    val (name,cf,iters,refV) = t
    val cfV = calc_i(cf,iters)
    println(name+":")
    println("ref value: "+refV.substring(0,34))
    println("cf value:  "+(cfV.toString+" "*34).substring(0,34))
    println("precision: "+approx(cfV,refV))
    println()
  }
}
