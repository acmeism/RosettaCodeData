func compare (a: String, b: String) {
  if a == b {
    println("'\(a)' and '\(b)' are lexically equal.")
  }
  if a != b {
    println("'\(a)' and '\(b)' are not lexically equal.")
  }

  if a < b {
    println("'\(a)' is lexically before '\(b)'.")
  }
  if a > b {
    println("'\(a)' is lexically after '\(b)'.")
  }

  if a >= b {
    println("'\(a)' is not lexically before '\(b)'.")
  }
  if a <= b {
    println("'\(a)' is not lexically after '\(b)'.")
  }
}
compare("cat", "dog")
