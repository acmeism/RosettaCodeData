package main

import "fmt"

type Church func(Church) Church

func id[X any](x X) X {
  return x
}

func compose[X any, Y any, Z any](f func(Y) Z, g func(X) Y) func(X) Z {
  return func(x X) Z {
    return f(g(x))
  }
}

func zero() Church {
  return func(f Church) Church {
    return id[Church]
  }
}

func one() Church {
  return id[Church]
}

func succ(n Church) Church {
  return func(f Church) Church {
    return compose(f, n(f))
  }
}

func plus(m, n Church) Church {
  return func(f Church) Church {
    return compose(m(f), n(f))
  }
}

func mult(m, n Church) Church {
  return compose(m, n)
}

func exp(m, n Church) Church {
  return n(m)
}

func toInt(x Church) int {
  counter := 0
  fCounter := func(f Church) Church {
    counter++
    return f
  }

  x(fCounter)(id[Church])
  return counter
}

func toStr(x Church) string {
  counter := ""
  fCounter := func(f Church) Church {
    counter += "|"
    return f
  }

  x(fCounter)(id[Church])
  return counter
}

func main() {
  fmt.Println("zero =", toInt(zero()))

  one := one()
  fmt.Println("one =", toInt(one))

  two := succ(succ(zero()))
  fmt.Println("two =", toInt(two))

  three := plus(one, two)
  fmt.Println("three =", toInt(three))

  four := mult(two, two)
  fmt.Println("four =", toInt(four))

  eight := exp(two, three)
  fmt.Println("eight =", toInt(eight))

  fmt.Println("toStr(four) =", toStr(four))
}
