struct RecursiveFunc<F> {
  let o : RecursiveFunc<F> -> F
}

func Y<A, B>(f: (A -> B) -> A -> B) -> A -> B {
  let r = RecursiveFunc<A -> B> { w in f { w.o(w)($0) } }
  return r.o(r)
}

let fac = Y { (f: Int -> Int) in
  { $0 <= 1 ? 1 : $0 * f($0-1) }
}
let fib = Y { (f: Int -> Int) in
  { $0 <= 2 ? 1 : f($0-1)+f($0-2) }
}
println("fac(5) = \(fac(5))")
println("fib(9) = \(fib(9))")
