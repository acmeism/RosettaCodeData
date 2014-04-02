import scala.language.postfixOps

  def sieve(nums: Stream[Int]): Stream[Int] =
    Stream.cons(nums.head, sieve((nums.tail) filter (_ % nums.head != 0)))
  val primes = 2 #:: sieve(Stream.from(3, 2))

  println(primes take 10 toList) //         //List(2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
  println(primes takeWhile (_ < 30) toList) //List(2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
