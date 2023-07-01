def fdiff(xs: List[Int]) = (xs.tail, xs).zipped.map(_ - _)

def fdiffn(i: Int, xs: List[Int]): List[Int] = if (i == 1) fdiff(xs) else fdiffn(i - 1, fdiff(xs))
