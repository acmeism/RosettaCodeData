/*
Here is a basic list definition

sealed trait List[+A]
case class Cons[+A](head: A, tail: List[A]) extends List[A]
case object Nil extends List[Nothing]
*/

object List {
  def add[A](as: List[A], a: A): List[A] = Cons(a, as)
}
