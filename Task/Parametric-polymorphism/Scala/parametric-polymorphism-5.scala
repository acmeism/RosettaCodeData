case class Tree[+A](value: A, left: Option[Tree[A]], right: Option[Tree[A]]) {
  def map[B](f: A => B): Tree[B] =
    Tree(f(value), left map (_.map(f)), right map (_.map(f)))
  def find[B >: A](what: B): Boolean =
    (value == what) || left.map(_.find(what)).getOrElse(false) || right.map(_.find(what)).getOrElse(false)
}
