object ChowlaNumbers {
  def main(args: Array[String]): Unit = {
    println("Chowla Numbers...")
    for(n <- 1 to 37){println(s"$n: ${chowlaNum(n)}")}
    println("\nPrime Counts...")
    for(i <- (2 to 7).map(math.pow(10, _).toInt)){println(f"$i%,d: ${primesPar(i).size}%,d")}
    println("\nPerfect Numbers...")
    print(perfectsPar(35000000).toVector.sorted.zipWithIndex.map{case (n, i) => f"${i + 1}%,d: $n%,d"}.mkString("\n"))
  }

  def primesPar(num: Int): ParVector[Int] = ParVector.range(2, num + 1).filter(n => chowlaNum(n) == 0)
  def perfectsPar(num: Int): ParVector[Int] = ParVector.range(6, num + 1).filter(n => chowlaNum(n) + 1 == n)

  def chowlaNum(num: Int): Int = Iterator.range(2, math.sqrt(num).toInt + 1).filter(n => num%n == 0).foldLeft(0){case (s, n) => if(n*n == num) s + n else s + n + (num/n)}
}
