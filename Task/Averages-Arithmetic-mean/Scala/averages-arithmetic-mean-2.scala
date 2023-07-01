def mean[T](s: Seq[T])(implicit n: Integral[T]) = {
  import n._
  s.foldLeft(zero)(_+_) / fromInt(s.size)
}
