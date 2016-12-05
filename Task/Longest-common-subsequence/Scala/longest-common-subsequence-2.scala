  case class Memoized[A1, A2, B](f: (A1, A2) => B) extends ((A1, A2) => B) {
    val cache = scala.collection.mutable.Map.empty[(A1, A2), B]
    def apply(x: A1, y: A2) = cache.getOrElseUpdate((x, y), f(x, y))
  }

  lazy val lcsM: Memoized[List[Char], List[Char], List[Char]] = Memoized {
    case (_, Nil) => Nil
    case (Nil, _) => Nil
    case (x :: xs, y :: ys) if x == y => x :: lcsM(xs, ys)
    case (x :: xs, y :: ys)           => {
      (lcsM(x :: xs, ys), lcsM(xs, y :: ys)) match {
        case (xs, ys) if xs.length > ys.length => xs
        case (xs, ys)                          => ys
      }
    }
  }
