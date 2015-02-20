object APFSoEPagedOdds {
  import scala.annotation.tailrec

  private val CACHESZ = 1 << 18 //used cache buffer size
  private val PGSZ = CACHESZ / 4 //number of int's in cache
  private val PGBTS = PGSZ * 32 //number of bits in buffer

  //processing output type is a tuple of low bit (odds) address,
  // bit range size, and the actual culled page segment buffer.
  private type Chunk = (Long, Int, Array[Int])

  //produces an iteration of all the primes from an iteration of Chunks
  private def enumChnkPrms(chnks: Stream[Chunk]): Iterator[Long] = {
    def iterchnk(chnk: Chunk) = { //iterating primes per Chunk
      val (lw, rng, bf) = chnk
      @tailrec def nxtpi(i: Int): Int = { //find next prime index not composite
        if (i < rng && (bf(i >>> 5) & (1 << (i & 31))) != 0) nxtpi(i + 1) else i }
      Iterator.iterate(nxtpi(0))(i => nxtpi(i + 1)).takeWhile { _ < rng }
        .map { i => ((lw + i) << 1) + 3 } } //map from index to prime value
    chnks.toIterator.flatMap { iterchnk } }

  //culls the composite number bit representations from the bit-packed page buffer
  //using a given source of a base primes iterator
  private def cullPg(bsprms: Iterator[Long],
                     lowi: Long, buf: Array[Int]): Unit = {
    //cull for all base primes until square >= nxt
    val rng = buf.length * 32; val nxt = lowi + rng
    @tailrec def cull(bps: Iterator[Long]): Unit = {
      //given prime then calculate the base start address for prime squared
      val bp = bps.next(); val s = (bp * bp - 3) / 2
      //almost all of the execution time is spent in the following tight loop
      @tailrec def cullp(j: Int): Unit = { //cull the buffer for given prime
        if (j < rng) { buf(j >>> 5) |= 1 << (j & 31); cullp(j + bp.toInt) } }
      if (s < nxt) { //only cull for primes squared less than max
        //calculate the start address within this given page segment
        val strt = if (s >= lowi) (s - lowi).toInt else {
          val b = (lowi - s) % bp
          if (b == 0) 0 else (bp - b).toInt }
        cullp(strt); if (bps.hasNext) cull(bps) } } //loop for all primes in range
    //for the first page, use own bit pattern as a source of base primes
    //if another source is not given
    if (lowi <= 0 && bsprms.isEmpty)
      cull(enumChnkPrms(Stream((0, buf.length << 5, buf))))
    //otherwise use the given source of base primes
    else if (bsprms.hasNext) cull(bsprms) }

  //makes a chunk given a low address in (odds) bits
  private def mkChnk(lwi: Long): Chunk = {
    val rng = PGBTS; val buf = new Array[Int](rng / 32);
    val bps = if (lwi <= 0) Iterator.empty else enumChnkPrms(basePrms)
    cullPg(bps, lwi, buf); (lwi, rng, buf) }

  //new independent source of base primes in a stream of packed-bit arrays
  //memoized by converting it to a Stream and retaining a reference here
  private val basePrms: Stream[Chunk] =
    Stream.iterate(mkChnk(0)) { case (lw, rng, bf) => { mkChnk(lw + rng) } }

  //produces an infinite iterator over all the chunk results
  private def itrRslts[R](rsltf: Chunk => R): Iterator[R] = {
    def mkrslt(lwi: Long) = { //makes tuple of result and next low index
      val c = mkChnk(lwi); val (_, rng, _) = c; (rsltf(c), lwi + rng) }
    Iterator.iterate(mkrslt(0)) { case (_, nlwi) => mkrslt(nlwi) }
            .map { case (rslt, _) => rslt} } //infinite iteration of results

  //iterates across the "infinite" produced output primes
  def enumSoEPrimes(): Iterator[Long] = //use itrRsltsMP to produce Chunks iteration
    Iterator.single(2L) ++ enumChnkPrms(itrRslts { identity }.toStream)

  //counts the number of remaining primes in a page segment buffer
  //using a very fast bitcount per integer element
  //with special treatment for the last page
  private def countpgto(top: Long, b: Array[Int], nlwp: Long) = {
    val numbts = b.length * 32; val prng = numbts * 2
    @tailrec def cnt(i: Int, c: Int): Int = { //tight int bitcount loop
      if (i >= b.length) c else cnt (i + 1, c - Integer.bitCount(b(i))) }
    if (nlwp > top) { //for top in page, calculate int address containing top
      val bi = ((top - nlwp + prng) >>> 1).toInt
      val w = bi >>> 5; b(w) |= -2 << (bi & 31) //mark all following as composite
      for (i <- w + 1 until b.length) b(i) = -1 } //for all int's to end of buffer
    cnt(0, numbts) } //counting the entire buffer in every case

  //counts all the primes up to a top value
  def countSoEPrimesTo(top: Long): Long = {
    if (top < 2) return 0L else if (top < 3) return 1L //no work necessary
    //count all Chunks using multi-processing
    val gen = itrRslts { case (lwi, rng, bf) =>
      val nlwp = (lwi + rng) * 2 + 3; (countpgto(top, bf, nlwp), nlwp) }
    //a loop to take Chunk's up to including top limit but not past it
    @tailrec def takeUpto(acc: Long): Long = {
      val (cnt, nlwp) = gen.next(); val nacc = acc + cnt
      if (nlwp <= top) takeUpto(nacc) else nacc }; takeUpto(1) }
}
