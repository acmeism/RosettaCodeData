import lists, random


func treeInsert[T](tree: var DoublyLinkedNode[T]; node: DoublyLinkedNode[T]) =
  if tree.isNil: tree = node
  elif node.value < tree.value: tree.prev.treeInsert(node)
  else: tree.next.treeInsert(node)


func listFromTree[T](list: var DoublyLinkedList[T]; node: DoublyLinkedNode[T]) =
  if node.isNil: return
  let prev = node.prev
  let next = node.next
  list.listFromTree(prev)
  list.append(node)
  list.listFromTree(next)


func treeSort[T](list: DoublyLinkedList[T]): DoublyLinkedList[T] =
  var list = list
  if list.head == list.tail: return list
  var n = list.head
  var root: DoublyLinkedNode[T] = nil
  while not n.isNil:
    var next = n.next
    n.next = nil
    n.prev = nil
    root.treeInsert(n)
    n = next
  result = initDoublyLinkedList[T]()
  result.listFromTree(root)


randomize()
var list1 = initDoublyLinkedList[int]()
for i in 0..15: list1.append(rand(10..99))
echo "Before sort: ", list1
echo "After sort:  ", list1.treeSort()
echo()

var list2 = initDoublyLinkedList[string]()
for s in ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]:
  list2.append(s)
echo "Before sort: ", list2
echo "After sort:  ", list2.treeSort()
