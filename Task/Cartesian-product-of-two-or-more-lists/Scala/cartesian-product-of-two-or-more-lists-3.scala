cartesianProduct(List(3, 4), List(1, 2))
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
