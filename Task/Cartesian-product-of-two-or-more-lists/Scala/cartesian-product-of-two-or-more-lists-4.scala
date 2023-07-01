cartesianProduct(List(1, 2), List.empty)
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
