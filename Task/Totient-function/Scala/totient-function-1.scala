@tailrec
def gcd(a: Int, b: Int): Int = if(b == 0) a else gcd(b, a%b)
def totientLaz(num: Int): Int = LazyList.range(2, num).count(gcd(num, _) == 1) + 1
