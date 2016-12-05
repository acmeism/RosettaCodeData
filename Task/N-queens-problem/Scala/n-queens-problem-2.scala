def vecOk(v: IndexedSeq[Int])(f: (Int,Int) => Int): Boolean = {
  def vecOkIter(level: Int)(lst: List[Int]): Boolean = {
    if (level > -1) {
      val d = f(v(level),level)
      if (lst.contains(d)) false
      else vecOkIter(level-1)(d :: lst)
    }
    else true
  }
  vecOkIter(v.length-1)(List[Int]())
}

def nQueen(n: Int) = for (
  v <- (1 to n).permutations
  if vecOk(v)(_+_) && vecOk(v)(_-_)
) yield v

nQueen(8)
