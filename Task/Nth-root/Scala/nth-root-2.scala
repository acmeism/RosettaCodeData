def fallPrefix(itr: Iterator[Double]): Iterator[Double] = itr.sliding(2).dropWhile(p => p(0) > p(1)).map(_.head)
def nrootLazy(n: Int)(a: Double): Double = fallPrefix(Iterator.iterate(a){r => (((n - 1)*r) + (a/math.pow(r, n - 1)))/n}).next
