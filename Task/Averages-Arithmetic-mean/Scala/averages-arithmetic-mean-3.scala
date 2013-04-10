def mean[T](s: Seq[T])(implicit n: Fractional[T]) = n.div(s.sum, n.fromInt(s.size))
