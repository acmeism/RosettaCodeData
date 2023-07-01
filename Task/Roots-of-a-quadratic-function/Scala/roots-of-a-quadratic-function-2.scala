val equations=Array(
  (1.0, 22.0, -1323.0),   // two distinct real roots
  (6.0, -23.0, 20.0),     //   with a != 1.0
  (1.0, -1.0e9, 1.0),     //   with one root near zero
  (1.0, 2.0, 1.0),        // one real root (double root)
  (1.0, 0.0, 1.0),        // two imaginary roots
  (1.0, 1.0, 1.0)         // two complex roots
);
	
equations.foreach{v =>
  val (a,b,c)=v
  println("a=%g   b=%g   c=%g".format(a,b,c))
  val roots=solve(a, b, c)
  println("x1="+roots._1)
  if(roots._1 != roots._2) println("x2="+roots._2)
  println
}
