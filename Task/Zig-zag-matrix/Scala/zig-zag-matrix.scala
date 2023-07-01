  def zigzag(n: Int): Array[Array[Int]] = {
    val l = for (i <- 0 until n*n) yield (i%n, i/n)
    val lSorted = l.sortWith {
      case ((x,y), (u,v)) =>
        if (x+y == u+v)
          if ((x+y) % 2 == 0) x<u else y<v
        else x+y < u+v
    }
    val res = Array.ofDim[Int](n, n)
    lSorted.zipWithIndex foreach {
      case ((x,y), i) => res(y)(x) = i
    }
    res
  }

  zigzag(5).foreach{
    ar => ar.foreach(x => print("%3d".format(x)))
    println
  }
