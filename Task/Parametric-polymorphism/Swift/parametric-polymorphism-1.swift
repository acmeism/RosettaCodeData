class Tree<T> {
  var value: T?
  var left: Tree<T>?
  var right: Tree<T>?

  func replaceAll(value: T?) {
    self.value = value
    left?.replaceAll(value)
    right?.replaceAll(value)
  }
}
