def move(n: Int, from: Int, to: Int, via: Int) : Unit = {
    if (n == 1) {
      Console.println("Move disk from pole " + from + " to pole " + to)
    } else {
      move(n - 1, from, via, to)
      move(1, from, to, via)
      move(n - 1, via, to, from)
    }
  }
