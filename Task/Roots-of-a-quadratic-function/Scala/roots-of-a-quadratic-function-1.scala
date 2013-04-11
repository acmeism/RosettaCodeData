import ArithmeticComplex._
object QuadraticRoots {
  def solve(a:Double, b:Double, c:Double)={
    val d = b*b-4.0*a*c
    val aa = a+a

    if (d < 0.0) {  // complex roots
      val re= -b/aa;
      val im = math.sqrt(-d)/aa;
      (Complex(re, im), Complex(re, -im))
    }
    else { // real roots
      val re=if (b < 0.0) (-b+math.sqrt(d))/aa else (-b -math.sqrt(d))/aa
      (re, (c/(a*re)))
    }	
  }
}
