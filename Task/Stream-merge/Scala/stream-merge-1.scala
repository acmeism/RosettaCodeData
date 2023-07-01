def mergeN[A : Ordering](is: Iterator[A]*): Iterator[A] = is.reduce((a, b) => merge2(a, b))

def merge2[A : Ordering](i1: Iterator[A], i2: Iterator[A]): Iterator[A] = {
  merge2Buffered(i1.buffered, i2.buffered)
}

def merge2Buffered[A](i1: BufferedIterator[A], i2: BufferedIterator[A])(implicit ord: Ordering[A]): Iterator[A] = {
  if (!i1.hasNext) {
    i2
  } else if (!i2.hasNext) {
    i1
  } else {
    val nextHead = if (ord.lt(i1.head, i2.head)) {
      Iterator.single(i1.next)
    } else {
      Iterator.single(i2.next)
    }
    nextHead ++ merge2Buffered(i1, i2)
  }
}
