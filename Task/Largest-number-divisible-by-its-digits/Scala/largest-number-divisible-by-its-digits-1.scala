import scala.collection.mutable

def largestDecimal: Int = Iterator.from(98764321, -1).filter(chkDec).next
def chkDec(num: Int): Boolean = {
  val set = mutable.HashSet[Int]()
  num.toString.toVector.map(_.asDigit).forall(d => (d != 0) && (num%d == 0) && set.add(d))
}
