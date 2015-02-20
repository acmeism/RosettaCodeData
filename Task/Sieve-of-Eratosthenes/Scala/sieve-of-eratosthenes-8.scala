  class CIS[A](val start: A, val continue: () => CIS[A])

  def primesBirdCIS: Iterator[Int] = {
    def merge(xs: CIS[Int], ys: CIS[Int]): CIS[Int] = {
      val (x, y) = (xs.start, ys.start)

      if (y > x) new CIS(x, () => merge(xs.continue(), ys))
      else if (x > y) new CIS(y, () => merge(xs, ys.continue()))
      else new CIS(x, () => merge(xs.continue(), ys.continue()))
    }

    def primeMltpls(p: Int): CIS[Int] = {
      def nextCull(cull: Int): CIS[Int] = new CIS[Int](cull, () => nextCull(cull + 2 * p))
      nextCull(p * p)
    }

    def allMltpls(ps: CIS[Int]): CIS[CIS[Int]] =
      new CIS[CIS[Int]](primeMltpls(ps.start), () => allMltpls(ps.continue()))
    def join(ams: CIS[CIS[Int]]): CIS[Int] = {
      new CIS[Int](ams.start.start, () => merge(ams.start.continue(), join(ams.continue())))
    }

    def oddPrimes(): CIS[Int] = {
      def oddPrms(n: Int, composites: CIS[Int]): CIS[Int] = { //"minua"
        if (n >= composites.start) oddPrms(n + 2, composites.continue())
        else new CIS[Int](n, () => oddPrms(n + 2, composites))
      }
      //following uses a new recursive source of odd base primes
      new CIS(3, () => oddPrms(5, join(allMltpls(oddPrimes()))))
    }

    Iterator.single(2) ++ Iterator.iterate(oddPrimes())(_.continue()).map(_.start)
  }
