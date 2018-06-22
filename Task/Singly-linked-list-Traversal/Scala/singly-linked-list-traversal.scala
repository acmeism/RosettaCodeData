/*
Here is a basic list definition

sealed trait List[+A]
case class Cons[+A](head: A, tail: List[A]) extends List[A]
case object Nil extends List[Nothing]
*/

def traverse[A](as: List[A]): Unit = as match {
  case Nil => print("End")
  case Cons(h, t) => {
    print(h + " ")
    traverse(t)
  }
}
