def mult[A, CC[X] <: Seq[X], DD[Y] <: Seq[Y]](a: CC[DD[A]], b: CC[DD[A]])
(implicit n: Numeric[A]): CC[DD[A]] = {
  import n._
  for (row <- a)
  yield for(col <- b.transpose)
        yield row zip col map Function.tupled(_*_) reduceLeft (_+_)
}
