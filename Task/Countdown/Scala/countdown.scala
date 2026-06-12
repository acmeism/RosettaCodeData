var best = 0
var best_out = ""
val target = 952
val nbrs = List(100, 75, 50, 25, 6, 3)

def sol(target: Int, xs: List[Int], out: String): Unit = {
  if ((target - best).abs > (target - xs.head).abs) {
    best = xs.head
    best_out = out
  }
  if (target == xs.head)
    println(out)
  else
    0 until (xs.size-1) foreach { i1 =>
      (i1+1) until xs.size foreach { i2 =>
        val remains = xs.patch(i2, Nil, 1).patch(i1, Nil, 1)
        val (n1, n2) = (xs(i1), xs(i2))
        val (a, b) = (n1 min n2, n1 max n2)
        def loop(res: Int, op: Char) =
          sol(target, res :: remains, s"$out$b $op $a = $res ; ")
        loop(b + a, '+')
        if (b != a)
          loop(b - a, '-')
        if (a != 1) {
          loop(b * a, '*')
          if (b % a == 0)
            loop(b / a, '/')
        }
      }
    }
}

sol(target, nbrs, "")
if (best != target) {
  println("Best solution " + best)
  println(best_out)
}
