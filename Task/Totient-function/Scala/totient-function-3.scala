@tailrec
def scrub(f: Long, num: Long): Long = if(num%f == 0) scrub(f, num/f) else num
def totientLazPrd(num: Long): Long = LazyList.iterate((num, 2: Long, num)){case (ac, i, n) => if(n%i == 0) (ac*(i - 1)/i, i + 1, scrub(i, n)) else (ac, i + 1, n)}.find(_._3 == 1).get._1
