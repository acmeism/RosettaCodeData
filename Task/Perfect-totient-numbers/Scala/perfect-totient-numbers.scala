//List of perfect totients
def isPerfectTotient(num: Int): Boolean = LazyList.iterate(totient(num))(totient).takeWhile(_ != 1).foldLeft(0L)(_+_) + 1 == num
def perfectTotients: LazyList[Int] = LazyList.from(3).filter(isPerfectTotient)

//Totient Function
@tailrec def scrub(f: Long, num: Long): Long = if(num%f == 0) scrub(f, num/f) else num
def totient(num: Long): Long = LazyList.iterate((num, 2: Long, num)){case (ac, i, n) => if(n%i == 0) (ac*(i - 1)/i, i + 1, scrub(i, n)) else (ac, i + 1, n)}.dropWhile(_._3 != 1).head._1
