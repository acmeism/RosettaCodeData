  def nBytes(x: Double) = ((Math.log(x) / Math.log(2) + 1e-10).round + 1) / 8

  val primitives: List[(Any, Long)] =
    List((Byte, Byte.MaxValue),
      (Short, Short.MaxValue),
      (Int, Int.MaxValue),
      (Long, Long.MaxValue))

  primitives.foreach(t => println(f"A Scala ${t._1.toString.drop(13)}%-5s has ${nBytes(t._2)} bytes"))
