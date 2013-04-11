class Hamming extends Iterator[BigInt] {
  import scala.collection.mutable.Queue
  val qs = Seq.fill(3)(new Queue[BigInt])
  def enqueue(n: BigInt) = qs zip Seq(2, 3, 5) foreach { case (q, m) => q enqueue n * m }
  def next = {
    val n = qs map (_.head) min;
    qs foreach { q => if (q.head == n) q.dequeue }
    enqueue(n)
    n
  }
  def hasNext = true
  qs foreach (_ enqueue 1)
}
