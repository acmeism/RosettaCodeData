import strutils, tables

type

  Node*[T] = ref object
    value: T
    parent: Node[T]
    child: Node[T]
    prev, next: Node[T]
    rank: int
    mark: bool

  Heap*[T] = object
    node: Node[T]


func meld1[T](list, single: Node[T]) =
  list.prev.next = single
  single.prev = list.prev
  single.next = list
  list.prev = single


func meld2[T](a, b: Node[T]) =
  a.prev.next = b
  b.prev.next = a
  swap a.prev, b.prev


# Task requirement.
func initHeap*[T]: Heap[T] = discard


# Task requirement.
func insert*[T](heap: var Heap[T]; value: T): Node[T] =
  result = Node[T](value: value)
  if heap.node.isNil:
    result.next = result
    result.prev = result
    heap.node = result
  else:
    heap.node.meld1(result)
    if result.value < heap.node.value:
      heap.node = result


# Task requirement.
func union*[T](heap1: var Heap[T]; heap2: var Heap[T]) =
  if heap1.node.isNil:
    heap1 = heap2
  elif not heap2.node.isNil:
    meld2(heap1.node, heap2.node)
    if heap2.node.value < heap1.node.value:
      heap1 = heap2
  heap2.node = nil


# Task requirement.
func min*[T](heap: Heap[T]): T =
  if heap.node.isNil:
    raise newException(ValueError, "cannot find minimum value in an empty heap.")
  result = heap.node.value


func add[T](roots: var Table[int, Node[T]]; root: Node[T]) =
  root.prev = root
  root.next = root
  var root = root
  while true:
    if root.rank notin roots: break
    var node = roots.getOrDefault(root.rank, nil)
    if node.isNil: break
    roots.del(root.rank)
    if node.value < root.value: swap node, root
    node.parent = root
    node.mark = false
    if root.child.isNil:
      node.next = node
      node.prev = node
      root.child = node
    else:
      meld1(root.child, node)
    inc root.rank
  roots[root.rank] = root


proc firstKey[T1, T2](t: Table[T1, T2]): T1 =
  for key in t.keys: return key


# Task requirement.
func extractMin*[T](heap: var Heap[T]): T =
  let m = min(heap)
  var roots: Table[int, Node[T]]

  var root = heap.node.next
  while root != heap.node:
    let node = root.next
    roots.add root
    root = node

  var child = heap.node.child
  if not child.isNil:
    child.parent = nil
    var root = child.next
    roots.add child
    while root != child:
      let node = root.next
      root.parent = nil
      roots.add root
      root = node

  if roots.len == 0:
    heap.node = nil
    return m

  let key = roots.firstKey()
  var node = roots[key]
  roots.del(key)
  node.next = node
  node.prev = node
  for root in roots.values:
    root.prev = node
    root.next = node.next
    node.next.prev = root
    node.next = root
    if root.value < node.value: node = root
  heap.node = node
  result = m


# Forward reference.
func cutAndMeld[T](heap: Heap[T]; node: Node[T])


func cut[T](heap: Heap[T]; node: Node[T]) =
  let parent = node.parent
  dec parent.rank
  if parent.rank == 0:
    parent.child = nil
  else:
    parent.child = node.next
    node.prev.next = node.next
    node.next.prev = node.prev
  if parent.parent.isNil: return
  if parent.mark:
    heap.cutAndMeld(parent)
  else:
    parent.mark = true


func cutAndMeld[T](heap: Heap[T]; node: Node[T]) =
  heap.cut(node)
  node.parent = nil
  meld1(heap.node, node)


# Task requirement.
func decreaseKey*[T](heap: var Heap[T]; node: Node[T]; val: T) =
  if node.value < val:
    raise newException(ValueError, "“decreaseKey” new value greater than existing value.")

  node.value = val
  if node == heap.node: return

  if node.parent.isNil:
    if val < heap.node.value:
      heap.node = node
  else:
    heap.cutAndMeld(node)


# Task requirement.
func delete*[T](heap: var Heap[T]; node: Node[T]) =

  let parent = node.parent
  if parent.isNil:
    if node == heap.node:
      discard heap.extractMin()
      return
    node.prev.next = node.next
    node.next.prev = node.prev
  else:
    heap.cut(node)

  var child = node.child
  if child.isNil: return

  while true:
    child.parent = nil
    child = child.next
    if child == node.child: break

  meld2(heap.node, child)


iterator nodes[T](head: Node[T]): Node[T] =
  if not head.isNil:
    yield head
    var node = head.next
    while node != head:
      yield node
      node = node.next


proc visualize[T](heap: Heap[T]) =

  if heap.node.isNil:
    echo "<empty>"
    return

  proc print[T](node: Node[T]; pre: string) =
    var pc = "│ "
    for curr in node.nodes():
      if curr.next != node:
        stdout.write pre, "├─"
      else:
        stdout.write pre, "└─"
        pc = "  "
      if curr.child.isNil:
        echo "╴", curr.value
      else:
        echo "┐", curr.value
        print(curr.child, pre & pc)

  print(heap.node, "")


when isMainModule:

  echo "MakeHeap:"
  var heap = initHeap[string]()
  heap.visualize()

  echo "\nInsert:"
  discard heap.insert("cat")
  heap.visualize()

  echo "\nUnion:"
  var heap2 = initHeap[string]()
  discard heap2.insert("rat")
  heap.union(heap2)
  heap.visualize()

  echo "\nMinimum:"
  var m = min(heap)
  echo m

  echo "\nExtractMin:"
  # Add a couple more items to demonstrate parent-child linking that happens on delete min.
  discard heap.insert("bat")
  let node = heap.insert("meerkat")  # Save node for decrease key and delete demos.
  m = heap.extractMin()
  echo "(extracted $#)" % m
  heap.visualize()

  echo "\nDecreaseKey:"
  heap.decreaseKey(node, "gnat")
  heap.visualize()

  echo "\nDelete:"
  # Add a couple more items.
  discard heap.insert("bobcat")
  discard heap.insert("bat")
  echo "(deleting $#)" % node.value
  heap.delete(node)
  heap.visualize()
