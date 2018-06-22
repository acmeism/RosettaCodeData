sealed trait List[+A]
case class Cons[+A](head: A, tail: List[A]) extends List[A]
case object Nil extends List[Nothing]

object List {
  def apply[A](as: A*): List[A] =
    if (as.isEmpty) Nil else Cons(as.head, apply(as.tail: _*))
}
