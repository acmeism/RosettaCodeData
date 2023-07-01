object SoEwithBitSet {
  def makeSoE_PrimesTo(top: Int): Iterator[Int] = {
    val topNdx = (top - 3) / 2 //odds composite BitSet buffer offset down to 3
    val cmpsts = new scala.collection.mutable.BitSet(topNdx + 1) //size includes topNdx
    @inline def cullPrmCmpsts(prmNdx: Int) = {
      val prm = prmNdx + prmNdx + 3; cmpsts ++= ((prm * prm - 3) >>> 1 to topNdx by prm) }
    (0 to (Math.sqrt(top).toInt - 3) / 2).filterNot { cmpsts }.foreach { cullPrmCmpsts }
    Iterator.single(2) ++ (0 to topNdx).filterNot { cmpsts }.map { pi => pi + pi + 3 } }
}
