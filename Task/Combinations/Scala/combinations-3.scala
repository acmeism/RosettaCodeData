  def combs[A](n: Int, xs: List[A]): Stream[List[A]] =
    combsBySize(xs)(n)

  def combsBySize[A](xs: List[A]): Stream[Stream[List[A]]] = {
    val z: Stream[Stream[List[A]]] = Stream(Stream(List())) ++ Stream.continually(Stream.empty)
    xs.toStream.foldRight(z)((a, b) => zipWith[Stream[List[A]]](_ ++ _, f(a, b), b))
  }

  def zipWith[A](f: (A, A) => A, as: Stream[A], bs: Stream[A]): Stream[A] = (as, bs) match {
    case (Stream.Empty, _) => Stream.Empty
    case (_, Stream.Empty) => Stream.Empty
    case (a #:: as, b #:: bs) => f(a, b) #:: zipWith(f, as, bs)
  }

  def f[A](x: A, xsss: Stream[Stream[List[A]]]): Stream[Stream[List[A]]] =
    Stream.empty #:: xsss.map(_.map(x :: _))
