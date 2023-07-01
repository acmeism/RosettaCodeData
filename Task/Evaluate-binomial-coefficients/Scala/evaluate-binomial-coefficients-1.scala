object Binomial {
   def main(args: Array[String]): Unit = {
      val n=5
      val k=3
      val result=binomialCoefficient(n,k)
      println("The Binomial Coefficient of %d and %d equals %d.".format(n, k, result))
   }

   def binomialCoefficient(n:Int, k:Int)=fact(n) / (fact(k) * fact(n-k))
   def fact(n:Int):Int=if (n==0) 1 else n*fact(n-1)
}
