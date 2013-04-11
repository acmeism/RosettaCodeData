    case (x :: xs, y :: ys) if x < y => Stream.cons(x, merge(xs, right))
    case (x :: xs, y :: ys) => Stream.cons(y, merge(left, ys))
