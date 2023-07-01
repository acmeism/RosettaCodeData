scala> import org.rosettacode.ArithmeticComplex._
import org.rosettacode.ArithmeticComplex._

scala> 1 + i
res0: org.rosettacode.ArithmeticComplex.Complex = 1.0 + 1.0i

scala> 1 + 2 * i
res1: org.rosettacode.ArithmeticComplex.Complex = 1.0 + 2.0i

scala> 2 + 1.i
res2: org.rosettacode.ArithmeticComplex.Complex = 2.0 + 1.0i

scala> res0 + res1
res3: org.rosettacode.ArithmeticComplex.Complex = 2.0 + 3.0i

scala> res1 * res2
res4: org.rosettacode.ArithmeticComplex.Complex = 0.0 + 5.0i

scala> res2 / res0
res5: org.rosettacode.ArithmeticComplex.Complex = 1.5 + -0.5i

scala> res1.inverse
res6: org.rosettacode.ArithmeticComplex.Complex = 0.2 + -0.4i

scala> -res6
res7: org.rosettacode.ArithmeticComplex.Complex = -0.2 + 0.4i
