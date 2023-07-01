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

proc `$`[T](list: SinglyLinkedList[T]): string =
  var s: seq[T]
  var n = list.head
  while not n.isNil:
    s.add n.data
    n = n.next
  result = s.join(" → ")

var list: SinglyLinkedList[int]

for i in 1..5: list.append(i)
for i in 6..10: list.prepend(i)
echo "List: ", list
