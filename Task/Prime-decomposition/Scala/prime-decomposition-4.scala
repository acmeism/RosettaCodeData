import spire.math.SafeLong
import spire.implicits._
def pFactors(num: SafeLong): Vector[SafeLong] = Iterator.iterate((Vector[SafeLong](), num, SafeLong(2))){case (ac, n, f) => if(n%f == 0) (ac :+ f, n/f, f) else (ac, n, f + 1)}.dropWhile(_._2 != 1).next._1
