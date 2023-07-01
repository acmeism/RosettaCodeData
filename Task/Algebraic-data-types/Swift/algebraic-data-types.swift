enum Color { case R, B }
enum Tree<A> {
  case E
  indirect case T(Color, Tree<A>, A, Tree<A>)
}

func balance<A>(input: (Color, Tree<A>, A, Tree<A>)) -> Tree<A> {
  switch input {
  case let (.B, .T(.R, .T(.R,a,x,b), y, c), z, d): return .T(.R, .T(.B,a,x,b), y, .T(.B,c,z,d))
  case let (.B, .T(.R, a, x, .T(.R,b,y,c)), z, d): return .T(.R, .T(.B,a,x,b), y, .T(.B,c,z,d))
  case let (.B, a, x, .T(.R, .T(.R,b,y,c), z, d)): return .T(.R, .T(.B,a,x,b), y, .T(.B,c,z,d))
  case let (.B, a, x, .T(.R, b, y, .T(.R,c,z,d))): return .T(.R, .T(.B,a,x,b), y, .T(.B,c,z,d))
  case let (col, a, x, b)                        : return .T(col, a, x, b)
  }
}

func insert<A : Comparable>(x: A, s: Tree<A>) -> Tree<A> {
  func ins(s: Tree<A>) -> Tree<A> {
    switch s {
    case     .E           : return .T(.R,.E,x,.E)
    case let .T(col,a,y,b):
      if x < y {
        return balance((col, ins(a), y, b))
      } else if x > y {
        return balance((col, a, y, ins(b)))
      } else {
        return s
      }
    }
  }
  switch ins(s) {
  case let .T(_,a,y,b): return .T(.B,a,y,b)
  case     .E:
    assert(false)
    return .E
  }
}
