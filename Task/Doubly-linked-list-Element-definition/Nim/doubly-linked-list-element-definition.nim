type
  Node[T] = ref TNode[T]

  TNode[T] = object
    next, prev: Node[T]
    data: T
