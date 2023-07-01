def powerset[A](s: Set[A]) = (0 to s.size).map(s.toSeq.combinations(_)).reduce(_ ++ _).map(_.toSet)
