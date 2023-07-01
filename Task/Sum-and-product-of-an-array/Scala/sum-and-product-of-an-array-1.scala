val seq = Seq(1, 2, 3, 4, 5)
val sum = seq.foldLeft(0)(_ + _)
val product = seq.foldLeft(1)(_ * _)
