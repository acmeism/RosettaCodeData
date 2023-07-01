func a(v: Bool) -> Bool {
  print("a")
  return v
}

func b(v: Bool) -> Bool {
  print("b")
  return v
}

func test(i: Bool, j: Bool) {
  println("Testing a(\(i)) && b(\(j))")
  print("Trace:  ")
  println("\nResult: \(a(i) && b(j))")

  println("Testing a(\(i)) || b(\(j))")
  print("Trace:  ")
  println("\nResult: \(a(i) || b(j))")

  println()
}

test(false, false)
test(false, true)
test(true, false)
test(true, true)
