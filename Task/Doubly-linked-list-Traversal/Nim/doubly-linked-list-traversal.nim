type
  List[T] = object
    head, tail: Node[T]

  Node[T] = ref TNode[T]

  TNode[T] = object
    next, prev: Node[T]
    data: T

proc initList[T](): List[T] = discard

proc newNode[T](data: T): Node[T] =
  new(result)
  result.data = data

proc prepend[T](l: var List[T], n: Node[T]) =
  n.next = l.head
  if l.head != nil: l.head.prev = n
  l.head = n
  if l.tail == nil: l.tail = n

proc append[T](l: var List[T], n: Node[T]) =
  n.next = nil
  n.prev = l.tail
  if l.tail != nil:
    l.tail.next = n
  l.tail = n
  if l.head == nil:
    l.head = n

proc insertAfter[T](l: var List[T], r, n: Node[T]) =
  n.prev = r
  n.next = r.next
  n.next.prev = n
  r.next = n
  if r == l.tail: l.tail = n

proc remove[T](l: var List[T], n: Node[T]) =
  if n == l.tail: l.tail = n.prev
  if n == l.head: l.head = n.next
  if n.next != nil: n.next.prev = n.prev
  if n.prev != nil: n.prev.next = n.next

proc `$`[T](l: var List[T]): string =
  result = ""
  var n = l.head
  while n != nil:
    if result.len > 0: result.add(" -> ")
    result.add($n.data)
    n = n.next

iterator traverseForward[T](l: List[T]): T =
  var n = l.head
  while n != nil:
    yield n.data
    n = n.next

iterator traverseBackward[T](l: List[T]): T =
  var n = l.tail
  while n != nil:
    yield n.data
    n = n.prev

var l = initList[int]()
var n = newNode(12)
var m = newNode(13)
var i = newNode(14)
var j = newNode(15)
l.append(n)
l.prepend(m)
l.insertAfter(m, i)
l.prepend(j)
l.remove(m)

for i in l.traverseForward():
  echo "> ", i

for i in l.traverseBackward():
  echo "< ", i
