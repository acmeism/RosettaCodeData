case class Tree[+A](value: A, left: Option[Tree[A]], right: Option[Tree[A]]) {
  def map[B](f: A => B): Tree[B] =
    Tree(f(value), left map (_.map(f)), right map (_.map(f)))
}
