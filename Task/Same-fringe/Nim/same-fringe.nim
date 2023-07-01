import random, sequtils, strutils

type Node = ref object
  value: int
  left, right: Node


proc add(tree: var Node; value: int) =
  ## Add a node to a tree (or subtree), insuring values are in increasing order.
  if tree.isNil:
    tree = Node(value: value)
  elif value <= tree.value:
    tree.left.add value
  else:
    tree.right.add value


proc newTree(list: varargs[int]): Node =
  ## Create a new tree with the given nodes.
  for value in list:
    result.add value


proc `$`(tree: Node): string =
  # Display a tree.
  if tree.isNil: return
  result = '(' & $tree.left & $tree.value & $tree.right & ')'


iterator nodes(tree: Node): Node =
  ## Yield the successive leaves of a tree.
  ## Iterators cannot be recursive, so we have to manage a stack.
  ## Note: with Nim 1.4 a bug prevents to use a closure iterator,
  ## so we use an inline iterator which is not optimal here.

  type
    Direction {.pure.} = enum Up, Down
    Item = (Node, Direction)

  var stack: seq[Item]
  stack.add (nil, Down) # Sentinel to avoid checking for empty stack.

  var node = tree
  var dir = Down

  while not node.isNil:
    if dir == Down and not node.left.isNil:
      # Process left subtree.
      stack.add (node, Up)
      node = node.left
    else:
      yield node
      # Process right subtree of pop an element form stack.
      (node, dir) = if node.right.isNil: stack.pop() else: (node.right, Down)


proc haveSameFringe(tree1, tree2: Node): bool =
  ## Return true if the trees have the same fringe.
  ## Check is done node by node and terminates as soon as
  ## a difference is encountered.
  let iter1 = iterator: Node = (for node in tree1.nodes: yield node)
  let iter2 = iterator: Node = (for node in tree2.nodes: yield node)
  while true:
    let node1 = iter1()
    let node2 = iter2()
    if iter1.finished and iter2.finished: return true # Both terminates at same round.
    if iter1.finished or iter2.finished: return false # One terminates  before the other.
    if node1.value != node2.value: return false


when isMainModule:
  randomize()
  var values = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  values.shuffle()
  let tree1 = newTree(values)
  echo "First tree:  ", tree1

  values.shuffle()
  let tree2 = newTree(values)
  echo "Second tree: ", tree2

  let s = if haveSameFringe(tree1, tree2): "have " else: "don’t have "
  echo "The trees ", s, "same fringe: ", toSeq(tree1.nodes()).mapIt(it.value).join(", ")
