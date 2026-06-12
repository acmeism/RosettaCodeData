import std/strformat

type

  Color {.pure.} = enum Black = "BLACK", Red = "RED"

  Node = ref object
    val: Positive   # Value of node.
    parent: Node    # Parent of node.
    left: Node      # Left child of node.intint
    right: Node     # Right child of node.
    color: Color    # Color of node.

  RBTree = object
    null: Node
    root: Node


func initRBTree(): RBTree =
  result.null = Node(val: 0, color: Black)
  result.root = result.null


func leftRotate(tree: var RBTree; x: Node) =

  let y = x.right
  x.right = y.left              # Change right child of x to left child of y.
  if y.left != tree.null:
    y.left.parent = x

  y.parent = x.parent           # Change parent of y as parent of x.
  if x.parent.isNil:
    tree.root = y
  elif x == x.parent.left:
    x.parent.left = y
  else:
    x.parent.right = y
  y.left = x
  x.parent = y


func rightRotate(tree: var RBTree; x: Node) =

  let y = x.left
  x.left = y.right              # Change left child of x to right child of y.
  if y.right != tree.null:
    y.right.parent = x

  y.parent = x.parent           # Change parent of y as parent of x.
  if x.parent.isNil:
    tree.root = y
  elif x == x.parent.right:
    x.parent.right = y
  else :
    x.parent.left = y
  y.right = x
  x.parent = y


func fixInsert(tree: var RBTree; k: Node) =
  ## Fix up insertion.
  var k = k
  while k.parent.color == Red:
    if k.parent == k.parent.parent.right:
      let u = k.parent.parent.left
      if u.color == Red:
        u.color = Black
        k.parent.color = Black
        k.parent.parent.color = Red
        k = k.parent.parent         # Repeat the algorithm with parent node to check conflicts.
      else:
        if k == k.parent.left:
          k = k.parent
          tree.rightRotate(k)
        k.parent.color = Black
        k.parent.parent.color = Red
        tree.leftRotate(k.parent.parent)
    else:
      let u = k.parent.parent.right
      if u.color == Red:
        u.color = Black
        k.parent.color = Black
        k.parent.parent.color = Red
        k = k.parent.parent         # Repeat algorithm on grandparent to remove conflicts.
      else:
        if k == k.parent.right:
          k = k.parent
          tree.leftRotate(k)
        k.parent.color = Black
        k.parent.parent.color = Red
        tree.rightRotate(k.parent.parent)
    if k == tree.root:
      break
  tree.root.color = Black


func fixDelete (tree: var RBTree; x: Node) =
  ## Fix issues after deletion.

  var x = x
  while x != tree.root and x.color == Black:
    if x == x.parent.left:
      var s = x.parent.right
      if s.color == Red :
        s.color = Black
        x.parent.color = Red
        tree.leftRotate(x.parent)
        s = x.parent.right
      if s.left.color == Black and s.right.color == Black :
        s.color = Red
        x = x.parent
      else :
        if s.right.color == Black :
          s.left.color = Black
          s.color = Red
          tree.rightRotate(s)
          s = x.parent.right

        s.color = x.parent.color
        x.parent.color = Black
        s.right.color = Black
        tree.leftRotate(x.parent)
        x = tree.root
    else :
      var s = x.parent.left
      if s.color == Red:
        s.color = Black
        x.parent.color = Red
        tree.rightRotate(x.parent)
        s = x.parent.left

      if s.right.color == Black and s.right.color == Black:
        s.color = Red
        x = x.parent
      else :
        if s.left.color == Black:
          s.right.color = Black
          s.color = Red
          tree.leftRotate(s)
          s = x.parent.left

        s.color = x.parent.color
        x.parent.color = Black
        s.left.color = Black
        tree.rightRotate(x.parent)
        x = tree.root
  x.color = Black


func insert(tree: var RBTree; key: Positive) =
  ## Insert a new node.

  let node = Node(val: key, left: tree.null, right: tree.null, color: Red)

  # Find position for new node.
  var y: Node
  var x = tree.root
  while x != tree.null:
    y = x
    x = if node.val < x.val: x.left
        else: x.right

  node.parent = y
  if y.isNil:
    # If parent is nil then it is the root node.
    tree.root = node
  elif node.val < y.val:
    y.left = node
  else:
    y.right = node

  if node.parent.isNil:
    node.color = Black    # Root node is always black.
    return

  if node.parent.parent.isNil:
    # If parent node is the root node.
    return

  tree.fixInsert(node)


func min(tree: RBTree; node: Node): Node =
  result = node
  while result.left != tree.null:
    result = result.left


func rbTransplant(tree: var RBTree; u, v: Node) =
  ## Transplant nodes.
  if u.parent.isNil:
    tree.root = v
  elif u == u.parent.left:
    u.parent.left = v
  else:
    u.parent.right = v
  v.parent = u.parent


proc deleteHelper(tree: var RBTree; node: Node; key: Positive) =
  ## Function to handle deletion.

  var node = node
  var z = tree.null
  while node != tree.null:  # Search for the node having that value/key and store it in 'z'.
    if node.val == key:
      z = node
    node = if node.val <= key: node.right
           else: node.left

  if z == tree.null:        # If key is not present then deletion is not possible so return.
    echo "Value not present in tree!"
    return

  var x: Node
  var y = z
  var yOriginalColor = y.color
  if z.left == tree.null:
    x = z.right
    tree.rbTransplant(z, x)             # Transplant node to be deleted with x.
  elif (z.right == tree.null):
    x = z.left
    tree.rbTransplant(z, x)             # Transplant node to be deleted with x.
  else :
    y = tree.min(z.right)
    yOriginalColor = y.color
    x = y.right
    if y.parent == z:
      x.parent = y
    else:
      tree.rbTransplant(y, y.right)
      y.right = z.right
      y.right.parent = y

    tree.rbTransplant(z, y)
    y.left = z.left
    y.left.parent = y
    y.color = z.color
  if yOriginalColor == Black:           # If color is black then fixing is needed
    tree.fixDelete(x)


proc delete(tree: var RBTree; val: Positive)  =
  # Delete a node.
  tree.deleteHelper(tree.root, val)


proc print(tree: RBTree; node: Node; indent: string; last: bool) =
  ## Print part of a tree.

  var indent = indent
  if node != tree.null:
    stdout.write indent, ' '
    if last:
      stdout.write "R----", ' '
      indent.add "     "
    else :
      stdout.write "L----", ' '
      indent.add "|    "

    echo &"{node.val}({node.color})"
    tree.print(node.left, indent, false)
    tree.print(node.right, indent, true)


proc print(tree: RBTree) =
  ## Print a tree.
  tree.print(tree.root, "", true)


when isMainModule:

  var bst = initRBTree()

  echo "State of the tree after inserting the 30 keys:"
  for x in 1..30:
    bst.insert(x)
  bst.print()

  echo "\nState of the tree after deleting the 15 keys:"
  for x in 1..15:
    bst.delete(x)
  bst.print()
