fn repeat(n int, f fn()) {
  for _ in 0.. n {
    f()
  }
}

fn func() {
  println("Example")
}

fn main() {
  repeat(4, func)
}
