pub fn swap(tuple: #(a, b)) -> #(b, a) {
  #(tuple.1, tuple.0)
}
