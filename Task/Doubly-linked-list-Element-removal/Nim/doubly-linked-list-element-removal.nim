type

  DoublyLinkedList[T] = object
    head, tail: Node[T]

  Node[T] = ref TNode[T]

  TNode[T] = object
    next, prev: Node[T]
    data: T

proc initDoublyLinkedList[T](): DoublyLinkedList[T] = discard

proc newNode[T](data: T): Node[T] =
  new(result)
  result.data = data

proc append[T](list: var DoublyLinkedList[T]; node: Node[T]) =
  node.next = nil
  node.prev = list.tail
  if not list.tail.isNil: list.tail.next = node
  list.tail = node
  if list.head.isNil: list.head = node

proc remove[T](list: var DoublyLinkedList; node: Node[T]) =
  if node == list.tail: list.tail = node.prev
  if node == list.head: list.head = node.next
  if not node.next.isNil: node.next.prev = node.prev
  if not node.prev.isNil: node.prev.next = node.next
  node.prev = nil
  node.next = nil

proc `$`[T](list: DoublyLinkedList[T]): string =
  var node = list.head
  while not node.isNil:
    if result.len > 0: result.add(" -> ")
    result.add $node.data
    node = node.next

var l = initDoublyLinkedList[int]()
let a = newNode(12)
let b = newNode(13)
let c = newNode(14)
let d = newNode(15)
l.append a
l.append b
l.append c
l.append d
echo l
l.remove b
echo l
l.remove a
echo l
l.remove d
echo l
l.remove c
echo l
