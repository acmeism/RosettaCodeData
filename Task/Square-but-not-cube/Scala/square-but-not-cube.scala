import spire.math.SafeLong
import spire.implicits._

def ncs: LazyList[SafeLong] = LazyList.iterate(SafeLong(1))(_ + 1).flatMap(n => Iterator.iterate(n.pow(3).sqrt + 1)(_ + 1).map(i => i*i).takeWhile(_ < (n + 1).pow(3)))
def scs: LazyList[SafeLong] = LazyList.iterate(SafeLong(1))(_ + 1).map(_.pow(3)).filter(n => n.sqrt.pow(2) == n)
