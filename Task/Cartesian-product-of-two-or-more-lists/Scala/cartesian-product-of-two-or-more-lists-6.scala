cartesianProduct(List(1776, 1789), List(7, 12), List(4, 14, 23), List(0, 1))
  .map(_.mkString("(", ", ", ")")).mkString("{",", ","}")
