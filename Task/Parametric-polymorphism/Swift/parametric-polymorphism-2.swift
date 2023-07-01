enum Tree<T> {
  case Empty
  indirect case Node(T, Tree<T>, Tree<T>)

  func map<U>(f : T -> U) -> Tree<U> {
    switch(self) {
    case     .Empty        : return .Empty
    case let .Node(x, l, r): return .Node(f(x), l.map(f), r.map(f))
    }
  }
}
