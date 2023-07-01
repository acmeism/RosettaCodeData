object HofstadterQseq extends App {

  val HofQ = scala.collection.mutable.Map((1->1),(2->1))

  val Q: Int => Int = n => {
    if (n < 1) 0
    else {
      val res = HofQ.keys.filter(_==n).toList match {
        case Nil => {val v = Q(n-Q(n-1))+Q(n-Q(n-2)); HofQ += (n->v); v}
        case xs => HofQ(n)
      }
      res
    }
  }

  (1 to 10).map(i=>(i,Q(i))).foreach(t=>println("Q("+t._1+") = "+t._2))
  println("Q("+1000+") = "+Q(1000))
  println((3 to 100000).filter(i=>Q(i)<Q(i-1)).size)
}
