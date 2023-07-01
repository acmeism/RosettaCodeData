def binarySearch[T](xs: Seq[T], x: T)(implicit ordering: Ordering[T]): Option[Int] = {
    var low: Int = 0
    var high: Int = xs.size - 1

    while (low <= high)
      low + high >>> 1 match {
        case guess if ordering.gt(xs(guess), x) => high = guess - 1 //too high
        case guess if ordering.lt(xs(guess), x) => low = guess + 1 // too low
        case guess => return Some(guess) //found it
      }
    None //not found
  }
