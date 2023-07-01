def fat(n: Int) = (2 to n).foldLeft(1)(_*_)
def perm[A](x: Int, a: Seq[A]): Seq[A] = if (x == 0) a else {
  val n = a.size
  val fatN1 = fat(n - 1)
  val fatN = fatN1 * n
  val p = x / fatN1 % fatN
  val (before, Seq(el, after @ _*)) = a splitAt p
  el +: perm(x % fatN1, before ++ after)
}
def findMissingPerm(start: String, perms: Array[String]): String = {
  for {
    i <- 0 until fat(start.size)
    p = perm(i, start).mkString
  } if (!perms.contains(p)) return p
  ""
}
val perms = """ABCD
CABD
ACDB
DACB
BCDA
ACBD
ADCB
CDAB
DABC
BCAD
CADB
CDBA
CBAD
ABDC
ADBC
BDCA
DCBA
BACD
BADC
BDAC
CBDA
DBCA
DCAB""".stripMargin.split("\n")
println(findMissingPerm(perms(0), perms))
