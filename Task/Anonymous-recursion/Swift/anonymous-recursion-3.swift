struct RecursiveFunc<F> {
  let o : RecursiveFunc<F> -> F
}

func y<A, B>(f: (A -> B) -> A -> B) -> A -> B {
  let r = RecursiveFunc<A -> B> { w in f { w.o(w)($0) } }
  return r.o(r)
}

func fib(n: Int) -> Int {
  assert(n >= 0, "fib: no negative numbers")
  return y {f in {n in n < 2 ? 1 : f(n-1) + f(n-2)}} (n)
}

println(fib(8))
