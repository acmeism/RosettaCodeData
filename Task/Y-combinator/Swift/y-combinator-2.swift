func Y<A, B>(f: (A -> B) -> A -> B) -> A -> B {
  typealias RecursiveFunc = Any -> A -> B
  let r : RecursiveFunc = { (z: Any) in let w = z as! RecursiveFunc; return f { w(w)($0) } }
  return r(r)
}
