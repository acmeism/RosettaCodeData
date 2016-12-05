  def hamming(): Stream[BigInt] = {
    def merge(a: Stream[BigInt], b: Stream[BigInt]): Stream[BigInt] = {
      if (a.isEmpty) b else {
        val av = a.head; val bv = b.head
        if (av < bv) av #:: merge(a.tail, b)
        else bv #:: merge(a, b.tail) } }
    def smult(m:Int, s: Stream[BigInt]): Stream[BigInt] =
      (m * s.head) #:: smult(m, s.tail) // equiv to map (m *) s; faster
    def u(s: Stream[BigInt], n: Int): Stream[BigInt] = {
      lazy val r: Stream[BigInt] = merge(s, smult(n, 1 #:: r))
      r }
    1 #:: List(5, 3, 2).foldLeft(Stream.empty[BigInt]) { u } }
