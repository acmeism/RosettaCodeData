func repeat(n: Int, f: () -> ()) {
  for _ in 0..<n {
    f()
  }
}

repeat(4) { println("Example") }
