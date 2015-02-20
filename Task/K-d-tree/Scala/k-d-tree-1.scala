object KDTree {
  import Numeric._

  // Task 1A. Build tree of KDNodes. Translated from Wikipedia.
  def apply[T](points: Seq[Seq[T]], depth: Int = 0)(implicit num: Numeric[T]): Option[KDNode[T]] = {
    val dim = points.headOption.map(_.size) getOrElse 0
    if (points.isEmpty || dim < 1) None
    else {
      val axis = depth % dim
      val sorted = points.sortBy(_(axis))
      val median = sorted(sorted.size / 2)(axis)
      val (left, right) = sorted.partition(v => num.lt(v(axis), median))
      Some(KDNode(right.head, apply(left, depth + 1), apply(right.tail, depth + 1), axis))
    }
  }

  // Task 1B. Find the nearest node in this subtree. Translated from Wikipedia.
  case class KDNode[T](value: Seq[T], left: Option[KDNode[T]], right: Option[KDNode[T]], axis: Int)(implicit num: Numeric[T]) {
    def nearest(to: Seq[T]): Nearest[T] = {
      val default = Nearest(value, to, Set(this))
      compare(to, value) match {
        case 0 => default // exact match
        case t =>
          lazy val bestL = left.map(_ nearest to).getOrElse(default)
          lazy val bestR = right.map(_ nearest to).getOrElse(default)
          val branch1 = if (t < 0) bestL else bestR
          val best = if (num.lt(branch1.distsq, default.distsq)) branch1 else default
          val splitDist = num.minus(to(axis), value(axis))
          if (num.lt(num.times(splitDist, splitDist), best.distsq)) {
            val branch2 = if (t < 0) bestR else bestL
            val visited = branch2.visited ++ best.visited + this
            if (num.lt(branch2.distsq, best.distsq))
              branch2.copy(visited = visited)
              else best.copy(visited = visited)
          } else best.copy(visited = best.visited + this)
      }
    }
  }

  // Keep track of nodes visited, as per task. Pretty-printable.
  case class Nearest[T](value: Seq[T], to: Seq[T], visited: Set[KDNode[T]] = Set[KDNode[T]]())(implicit num: Numeric[T]) {
    lazy val distsq = KDTree.distsq(value, to)
    override def toString = f"Searched for=${to} found=${value} distance=${math.sqrt(num.toDouble(distsq))}%.4f visited=${visited.size}"
  }

  // Numeric utilities
  def distsq[T](a: Seq[T], b: Seq[T])(implicit num: Numeric[T]) =
    a.zip(b).map(c => num.times(num.minus(c._1, c._2), num.minus(c._1, c._2))).sum
  def compare[T](a: Seq[T], b: Seq[T])(implicit num: Numeric[T]): Int =
    a.zip(b).find(c => num.compare(c._1, c._2) != 0).map(c => num.compare(c._1, c._2)).getOrElse(0)
}
