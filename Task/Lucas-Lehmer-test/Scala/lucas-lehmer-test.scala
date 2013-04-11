object LLT extends App {
  import Stream._

  def primeSieve(s: Stream[Int]): Stream[Int] = s.head #::primeSieve(s.tail filter { _ % s.head != 0 })
  def primes = primeSieve(from(2))
  def mersenne(p: Int): BigInt = (BigInt(2) pow p)-1

  val s: (BigInt,Int) => BigInt = (mp,p) => if (p==1) 4 else (((s(mp,p-1) pow 2)-2)%mp)

  (primes takeWhile (_<10000) map {p=>(p,mersenne(p))} map {p=>if (p._1==2) (p,0) else (p,s(p._2,p._1-1))} filter {_._2==0})
    .foreach {p=>println("prime M"+(p._1)._1+{if ((p._1)._1<200) ": "+(p._1)._2 else ": ("+(p._1)._2.toString.size+" digits)"})}
}
