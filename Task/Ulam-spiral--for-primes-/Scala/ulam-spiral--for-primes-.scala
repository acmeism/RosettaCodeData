object Ulam extends App {
    generate(9)()
    generate(9)('*')

    private object Direction extends Enumeration { val RIGHT, UP, LEFT, DOWN = Value }

    private def generate(n: Int, i: Int = 1)(c: Char = 0) {
        assert(n > 1, "n > 1")
        val s = new Array[Array[String]](n).transform {_ => new Array[String](n) }

        import Direction._
        var dir = RIGHT
        var y = n / 2
        var x = if (n % 2 == 0) y - 1 else y // shift left for even n's
        for (j <- i to n * n - 1 + i) {
            s(y)(x) = if (isPrime(j)) if (c == 0) "%4d".format(j) else s"  $c " else " ---"

            dir match {
                case RIGHT => if (x <= n - 1 && s(y - 1)(x) == null && j > i) dir = UP
                case UP => if (s(y)(x - 1) == null) dir = LEFT
                case LEFT => if (x == 0 || s(y + 1)(x) == null) dir = DOWN
                case DOWN => if (s(y)(x + 1) == null) dir = RIGHT
            }

            dir match {
                case RIGHT => x += 1
                case UP => y -= 1
                case LEFT => x -= 1
                case DOWN => y += 1
            }
        }
        println("[" + s.map(_.mkString("")).reduceLeft(_ + "]\n[" + _) + "]\n")
    }

    private def isPrime(a: Int): Boolean = {
        if (a == 2) return true
        if (a <= 1 || a % 2 == 0) return false
        val max = Math.sqrt(a.toDouble).toInt
        for (n <- 3 to max by 2)
            if (a % n == 0) return false
        true
    }
}
