  {
    var (x, l) = (0, List[Int]())
    do {
      x += 1
      l :+= x // A new copy of this list with List(x) appended.
    } while (x % 6 != 0)
    l
  }.foreach(println(_))
