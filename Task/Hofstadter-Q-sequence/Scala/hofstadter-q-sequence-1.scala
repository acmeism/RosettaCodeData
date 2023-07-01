object HofstadterQseq extends App {
  val Q: Int => Int = n => {
    if (n <= 2) 1
    else Q(n-Q(n-1))+Q(n-Q(n-2))
  }
  (1 to 10).map(i=>(i,Q(i))).foreach(t=>println("Q("+t._1+") = "+t._2))
  println("Q("+1000+") = "+Q(1000))
}
