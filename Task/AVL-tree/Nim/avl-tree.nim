#[ AVL tree adapted from Julienne Walker's presentation at
   http://eternallyconfuzzled.com/tuts/datastructures/jsw_tut_avl.aspx.

   Uses bounded recursive versions for insertion and deletion.
]#

type

  # Objects strored in the tree must be comparable.
  Comparable = concept x, y
    (x == y) is bool
    (x < y) is bool

  # Direction used to select a child.
  Direction = enum Left, Right

  # Description of the tree node.
  Node[T: Comparable] = ref object
    data: T                             # Payload.
    balance: range[-2..2]               # Balance factor (bounded).
    links: array[Direction, Node[T]]    # Children.

  # Description of a tree.
  AvlTree[T: Comparable] = object
    root: Node[T]


#---------------------------------------------------------------------------------------------------

func opp(dir: Direction): Direction {.inline.} =
  ## Return the opposite of a direction.
  Direction(1 - ord(dir))

#---------------------------------------------------------------------------------------------------

func single(root: Node; dir: Direction): Node =
  ## Single rotation.

  result = root.links[opp(dir)]
  root.links[opp(dir)] = result.links[dir]
  result.links[dir] = root

#---------------------------------------------------------------------------------------------------

func double(root: Node; dir: Direction): Node =
  ## Double rotation.

  let save = root.links[opp(dir)].links[dir]

  root.links[opp(dir)].links[dir] = save.links[opp(dir)]
  save.links[opp(dir)] = root.links[opp(dir)]
  root.links[opp(dir)] = save

  result = root.links[opp(dir)]
  root.links[opp(dir)] = result.links[dir]
  result.links[dir] = root

#---------------------------------------------------------------------------------------------------

func adjustBalance(root: Node; dir: Direction; balance: int) =
  ## Adjust balance factors after double rotation.

  let node1 = root.links[dir]
  let node2 = node1.links[opp(dir)]

  if node2.balance == 0:
    root.balance = 0
    node1.balance = 0

  elif node2.balance == balance:
    root.balance = -balance
    node1.balance = 0

  else:
    root.balance = 0
    node1.balance = balance

  node2.balance = 0

#---------------------------------------------------------------------------------------------------

func insertBalance(root: Node; dir: Direction): Node =
  ## Rebalancing after an insertion.

  let node = root.links[dir]
  let balance = 2 * ord(dir) - 1

  if node.balance == balance:
    root.balance = 0
    node.balance = 0
    result = root.single(opp(dir))

  else:
    root.adjustBalance(dir, balance)
    result = root.double(opp(dir))

#---------------------------------------------------------------------------------------------------

func insertR(root: Node; data: root.T): tuple[node: Node, done: bool] =
  ## Insert data (recursive way).

  if root.isNil:
    return (Node(data: data), false)

  let dir = if root.data < data: Right else: Left
  var done: bool
  (root.links[dir], done) = root.links[dir].insertR(data)
  if done:
    return (root, true)

  inc root.balance, 2 * ord(dir) - 1
  result = case root.balance
           of 0: (root, true)
           of -1, 1: (root, false)
           else: (root.insertBalance(dir), true)

#---------------------------------------------------------------------------------------------------

func removeBalance(root: Node; dir: Direction): tuple[node: Node, done: bool] =
  ## Rebalancing after a deletion.

  let node = root.links[opp(dir)]
  let balance = 2 * ord(dir) - 1
  if node.balance == -balance:
    root.balance = 0
    node.balance = 0
    result = (root.single(dir), false)
  elif node.balance == balance:
    root.adjustBalance(opp(dir), -balance)
    result = (root.double(dir), false)
  else:
    root.balance = -balance
    node.balance = balance
    result = (root.single(dir), true)

#---------------------------------------------------------------------------------------------------

func removeR(root: Node; data: root.T): tuple[node: Node, done: bool] =
  ## Remove data (recursive way).

  if root.isNil:
    return (nil, false)

  var data = data
  if root.data == data:
    if root.links[Left].isNil:
      return (root.links[Right], false)
    if root.links[Right].isNil:
      return (root.links[Left], false)
    var heir = root.links[Left]
    while not heir.links[Right].isNil:
      heir = heir.links[Right]
    root.data = heir.data
    data = heir.data

  let dir = if root.data < data: Right else: Left
  var done: bool
  (root.links[dir], done) = root.links[dir].removeR(data)
  if done:
    return (root, true)
  dec root.balance, 2 * ord(dir) - 1
  result = case root.balance
           of -1, 1: (root, true)
           of 0: (root, false)
           else: root.removeBalance(dir)

#---------------------------------------------------------------------------------------------------

func insert(tree: var AvlTree; data: tree.T) =
  ## Insert data in an AVL tree.
  tree.root = tree.root.insertR(data).node

#---------------------------------------------------------------------------------------------------

func remove(tree: var AvlTree; data: tree.T) =
  ## Remove data from an AVL tree.
  tree.root = tree.root.removeR(data).node

#———————————————————————————————————————————————————————————————————————————————————————————————————

import json

var tree: AvlTree[int]
echo pretty(%tree)

echo "Insert test:"
tree.insert(3)
tree.insert(1)
tree.insert(4)
tree.insert(1)
tree.insert(5)
echo pretty(%tree)

echo ""
echo "Remove test:"
tree.remove(3)
tree.remove(1)
echo pretty(%tree)
