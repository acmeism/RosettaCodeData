cartesianProduct(List(1, 2), List(3, 4))
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
