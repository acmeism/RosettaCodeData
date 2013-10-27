  val a = (1 to 10 /*1.*/ ).toList.splitAt(5) //2.
  println(List(a._1, a._2) /*3.*/ .map(_.mkString(", ") /*4.*/ ).mkString("\n") /*5.*/ )
