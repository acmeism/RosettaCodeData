  def hamming(): Stream[BigInt] = {
    def merge(a: Stream[BigInt], b: Stream[BigInt]): Stream[BigInt] = {
      val av = a.head; val bv = b.head
      if (av < bv) av #:: merge(a.tail, b)
      else bv #:: merge(a, b.tail)
    }
    def smult(m:BigInt, s: Stream[BigInt]): Stream[BigInt] =
      (m * s.head) #:: smult(m, s.tail) // equiv to map (m *) s - faster
    lazy val s5: Stream[BigInt] = 5 #:: smult(5, s5)
    lazy val s35: Stream[BigInt] = 3 #:: merge(s5, smult(3, s35))
    lazy val s235: Stream[BigInt] = 2 #:: merge(s35, smult(2, s235))
    1 #:: s235
  }
