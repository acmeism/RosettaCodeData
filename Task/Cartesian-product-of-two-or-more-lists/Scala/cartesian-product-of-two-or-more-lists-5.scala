cartesianProduct(List.empty, List(1, 2))
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
