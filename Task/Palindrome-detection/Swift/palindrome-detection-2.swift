func isPal(str: String) -> Bool {
  let c = str.characters
  return lazy(c).reverse()
    .startsWith(c[c.startIndex...advance(c.startIndex, c.count / 2)])
}
