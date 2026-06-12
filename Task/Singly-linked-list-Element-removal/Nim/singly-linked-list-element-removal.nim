import strutils

type

  Node[T] = ref object
    next: Node[T]
    data: T

  SinglyLinkedList[T] = object
    head, tail: Node[T]

proc newNode[T](data: T): Node[T] =
  Node[T](data: data)

proc append[T](list: var SinglyLinkedList[T]; node: Node[T]) =
  if list.head.isNil:
    list.head = node
    list.tail = node
  else:
    list.tail.next = node
    list.tail = node

proc append[T](list: var SinglyLinkedList[T]; data: T) =
  list.append newNode(data)

proc prepend[T](list: var SinglyLinkedList[T]; node: Node[T]) =
  if list.head.isNil:
    list.head = node
    list.tail = node
  else:
    node.next = list.head
    list.head = node

proc prepend[T](list: var SinglyLinkedList[T]; data: T) =
  list.prepend newNode(data)

proc remove[T](list: var SinglyLinkedList[T]; node: Node[T]) =
  if node.isNil:
    raise newException(ValueError, "trying to remove nil reference.")
  if node == list.head:
    list.head = list.head.next
    if list.head.isNil: list.tail = nil
  else:
    var n = list.head
    while not n.isNil and n.next != node:
      n = n.next
    if n.isNil: return  # Not found: ignore.
    n.next = node.next
    if n.next.isNil: list.tail = n

proc find[T](list: SinglyLinkedList[T]; data: T): Node[T] =
  result = list.head
  while not result.isNil and result.data != data:
    result = result.next

proc `$`[T](list: SinglyLinkedList[T]): string =
  var s: seq[T]
  var n = list.head
  while not n.isNil:
    s.add n.data
    n = n.next
  result = s.join(" → ")

var list: SinglyLinkedList[int]

for i in 1..5: list.append(i)
echo "List: ", list
list.remove(list.find(3))
echo "After removing 3: ", list
list.remove(list.find(1))
echo "After removing 1: ", list
list.remove(list.find(5))
echo "After removing 5: ", list
