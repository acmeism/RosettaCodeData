type Tree[T] = ref object
  value: T
  left, right: Tree[T]
