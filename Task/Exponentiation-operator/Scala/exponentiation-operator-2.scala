  @tailrec def powI[N](n: N, exponent: Int, acc:Int=1)(implicit num: Integral[N]): N = {
    exponent match {
      case 0 => acc
      case _ if exponent % 2 == 0 => powI(n * n, exponent / 2, acc)
      case _ => powI(n, (exponent - 1), acc*n)
    }
  }
