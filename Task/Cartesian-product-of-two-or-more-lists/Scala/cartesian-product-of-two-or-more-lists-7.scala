cartesianProduct(List(1, 2, 3), List(30), List(500, 100))
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
