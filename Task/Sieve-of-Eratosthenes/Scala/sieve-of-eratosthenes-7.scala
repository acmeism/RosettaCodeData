  def birdPrimes() = {
    def oddPrimes: Stream[Int] = {
      def merge(xs: Stream[Int], ys: Stream[Int]): Stream[Int] = {
        val (x, y) = (xs.head, ys.head)

        if (y > x) x #:: merge(xs.tail, ys) else if (x > y) y #:: merge(xs, ys.tail) else x #:: merge(xs.tail, ys.tail)
      }

      def primeMltpls(p: Int): Stream[Int] = Stream.iterate(p * p)(_ + p + p)

      def allMltpls(ps: Stream[Int]): Stream[Stream[Int]] = primeMltpls(ps.head) #:: allMltpls(ps.tail)

      def join(ams: Stream[Stream[Int]]): Stream[Int] = ams.head.head #:: merge(ams.head.tail, join(ams.tail))

      def oddPrms(n: Int, composites: Stream[Int]): Stream[Int] =
        if (n >= composites.head) oddPrms(n + 2, composites.tail) else n #:: oddPrms(n + 2, composites)

      //following uses a new recursive source of odd base primes
      3 #:: oddPrms(5, join(allMltpls(oddPrimes)))
    }
    2 #:: oddPrimes
  }
