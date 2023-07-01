object CF extends App {
  import Stream._
  val sqrt2 = 1 #:: from(2,0) zip from(1,0)
  val napier = 2 #:: from(1) zip (1 #:: from(1))
  val pi = 3 #:: from(6,0) zip (from(1,2) map {x=>x*x})

  // reference values, source: wikipedia
  val refPi     = "3.14159265358979323846264338327950288419716939937510"
  val refNapier = "2.71828182845904523536028747135266249775724709369995"
  val refSQRT2  = "1.41421356237309504880168872420969807856967187537694"

  def calc(cf: Stream[(Int, Int)], numberOfIters: Int=200): BigDecimal = {
    (cf take numberOfIters toList).foldRight[BigDecimal](1)((a, z) => a._1+a._2/z)
  }

  def approx(cfV: BigDecimal, cfRefV: String): String = {
    val p: Pair[Char,Char] => Boolean = pair =>(pair._1==pair._2)
    ((cfV.toString+" "*34).substring(0,34) zip cfRefV.toString.substring(0,34))
      .takeWhile(p).foldRight[String]("")((a:Pair[Char,Char],z)=>a._1+z)
  }

  List(("sqrt2",sqrt2,50,refSQRT2),("napier",napier,50,refNapier),("pi",pi,3000,refPi)) foreach {t=>
    val (name,cf,iters,refV) = t
    val cfV = calc(cf,iters)
    println(name+":")
    println("ref value: "+refV.substring(0,34))
    println("cf value:  "+(cfV.toString+" "*34).substring(0,34))
    println("precision: "+approx(cfV,refV))
    println()
  }
}
