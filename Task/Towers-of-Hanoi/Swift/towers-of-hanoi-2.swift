func hanoi(n:Int, a:String, b:String, c:String) {
  if (n > 0) {
    hanoi(n - 1, a: a, b: c, c: b)
    print("Move disk from \(a) to \(c)")
    hanoi(n - 1, a: b, b: a, c: c)
  }
}

hanoi(4, a:"A", b:"B", c:"C")
