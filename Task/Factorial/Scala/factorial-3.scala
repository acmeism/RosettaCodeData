def factorial(n: Int) = {
  @tailrec def fact(x: Int, acc: Int): Int = {
    if (x < 2) acc else fact(x - 1, acc * x)
  }
  fact(n, 1)
}
