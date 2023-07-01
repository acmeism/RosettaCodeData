def mult[A](a: Array[Array[A]], b: Array[Array[A]])(implicit n: Numeric[A]) = {
  import n._
  for (row <- a)
  yield for(col <- b.transpose)
        yield row zip col map Function.tupled(_*_) reduceLeft (_+_)
}
