  def lcsLazy[T](u: IndexedSeq[T], v: IndexedSeq[T]): IndexedSeq[T] = {
    def su = subsets(u).to(LazyList)
    def sv = subsets(v).to(LazyList)
    su.intersect(sv).headOption match{
      case Some(sub) => sub
      case None => IndexedSeq[T]()
    }
  }

  def subsets[T](u: IndexedSeq[T]): Iterator[IndexedSeq[T]] = {
    u.indices.reverseIterator.flatMap{n => u.indices.combinations(n + 1).map(_.map(u))}
  }
