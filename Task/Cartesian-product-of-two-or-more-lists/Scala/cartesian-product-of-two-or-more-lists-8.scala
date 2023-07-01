cartesianProduct(List(1, 2, 3), List.empty, List(500, 100))
  .map(_.mkString("[", ", ", "]")).mkString("\n")
