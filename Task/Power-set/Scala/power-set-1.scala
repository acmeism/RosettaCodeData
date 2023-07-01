import scala.compat.Platform.currentTime

object Powerset extends App {
  def powerset[A](s: Set[A]) = s.foldLeft(Set(Set.empty[A])) { case (ss, el) => ss ++ ss.map(_ + el)}

  assert(powerset(Set(1, 2, 3, 4)) == Set(Set.empty, Set(1), Set(2), Set(3), Set(4), Set(1, 2), Set(1, 3), Set(1, 4),
    Set(2, 3), Set(2, 4), Set(3, 4), Set(1, 2, 3), Set(1, 3, 4), Set(1, 2, 4), Set(2, 3, 4), Set(1, 2, 3, 4)))
  println(s"Successfully completed without errors. [total ${currentTime - executionStart} ms]")
}
