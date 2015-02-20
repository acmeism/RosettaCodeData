def binarySearch[A <% Ordered[A]](xs: Seq[A], x: A): Option[Int] = {
  var (low, high) = (0, xs.size - 1)
  while (low <= high)
    (low + high) / 2 match {
      case mid if xs(mid) > x => high = mid - 1
      case mid if xs(mid) < x => low = mid + 1
      case mid => return Some(mid)
    }
  None
}
