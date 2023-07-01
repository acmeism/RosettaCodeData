func succ<A, B, C>(_ n: @escaping (@escaping (A) -> B) -> (C) -> A) -> (@escaping (A) -> B) -> (C) -> B {
  return {f in
    return {x in
      return f(n(f)(x))
    }
  }
}

func zero<A, B>(_ a: A) -> (B) -> B {
  return {b in
    return b
  }
}

func three<A>(_ f: @escaping (A) -> A) -> (A) -> A {
  return {x in
    return succ(succ(succ(zero)))(f)(x)
  }
}

func four<A>(_ f: @escaping (A) -> A) -> (A) -> A {
  return {x in
    return succ(succ(succ(succ(zero))))(f)(x)
  }
}

func add<A, B, C>(_ m: @escaping (B) -> (A) -> C) -> (@escaping (B) -> (C) -> A) -> (B) -> (C) -> C {
  return {n in
    return {f in
      return {x in
        return m(f)(n(f)(x))
      }
    }
  }
}

func mult<A, B, C>(_ m: @escaping (A) -> B) -> (@escaping (C) -> A) -> (C) -> B {
  return {n in
    return {f in
      return m(n(f))
    }
  }
}

func exp<A, B, C>(_ m: A) -> (@escaping (A) -> (B) -> (C) -> C) -> (B) -> (C) -> C {
  return {n in
    return {f in
      return {x in
        return n(m)(f)(x)
      }
    }
  }
}

func church<A>(_ x: Int) -> (@escaping (A) -> A) -> (A) -> A {
  guard x != 0 else { return zero }

  return {f in
    return {a in
      return f(church(x - 1)(f)(a))
    }
  }
}

func unchurch<A>(_ f: (@escaping (Int) -> Int) -> (Int) -> A) -> A {
  return f({i in
    return i + 1
  })(0)
}

let a = unchurch(add(three)(four))
let b = unchurch(mult(three)(four))
// We can even compose operations
let c = unchurch(exp(mult(four)(church(1)))(three))
let d = unchurch(exp(mult(three)(church(1)))(four))

print(a, b, c, d)
