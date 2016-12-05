type Node[T] = ref object
  next: Node[T]
  data: T

proc newNode[T](data: T): Node[T] =
  Node[T](data: data)

var a = newNode 12
var b = newNode 13
var c = newNode 14
