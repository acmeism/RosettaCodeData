object LIFCI extends App {

  def lifci(list: List[Long]) = list.permutations.map(_.mkString).max

  println(lifci(List(1, 34, 3, 98, 9, 76, 45, 4)))
  println(lifci(List(54, 546, 548, 60)))
}
