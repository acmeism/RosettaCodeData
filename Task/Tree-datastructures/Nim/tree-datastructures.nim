import strformat, strutils


####################################################################################################
# Nested representation of trees.
# The tree is simply the first node.

type

  NNode*[T] = ref object
    value*: T
    children*: seq[NNode[T]]


proc newNNode*[T](value: T; children: varargs[NNode[T]]): NNode[T] =
  ## Create a node.
  NNode[T](value: value, children: @children)


proc add*[T](node: NNode[T]; children: varargs[NNode[T]]) =
  ## Add a list of chlidren to a node.
  node.children.add children


proc `$`*[T](node: NNode[T]; depth = 0): string =
  ## Return a string representation of a tree/node.
  result = repeat(' ', 2 * depth) & $node.value & '\n'
  for child in node.children:
    result.add `$`(child, depth + 1)


####################################################################################################
# Indented representation of trees.
# The tree is described as the list of the nodes.

type

  INode*[T] = object
    value*: T
    level*: Natural

  ITree*[T] = seq[INode[T]]


proc initINode*[T](value: T; level: Natural): INode[T] =
  ## Return a new node.
  INode[T](value: value, level: level)


proc initItree*[T](value: T): ITree[T] =
  ## Return a new tree initialized with the first node (root node).
  result = @[initINode(value, 0)]


proc add*[T](tree: var ITree[T]; nodes: varargs[INode[T]]) =
  ## Add a list of nodes to the tree.
  for node in nodes:
    if node.level - tree[^1].level > 1:
      raise newException(ValueError, &"wrong level {node.level} in node {node.value}.")
    tree.add node


proc `$`*[T](tree: ITree[T]): string =
  ## Return a string representation of a tree.
  for node in tree:
    result.add $node.level & ' ' & $node.value & '\n'


####################################################################################################
# Conversion between nested form and indented form.

proc toIndented*[T](node: NNode[T]): Itree[T] =
  ## Convert a tree in nested form to a tree in indented form.

  proc addNode[T](tree: var Itree[T]; node: NNode[T]; level: Natural) =
    ## Add a node to the tree at the given level.
    tree.add initINode(node.value, level)
    for child in node.children:
      tree.addNode(child, level + 1)

  result.addNode(node, 0)


proc toNested*[T](tree: Itree[T]): NNode[T] =
  ## Convert a tree in indented form to a tree in nested form.

  var stack: seq[NNode[T]]            # Note that stack.len is equal to the current level.
  var nnode = newNNode(tree[0].value) # Root.
  for i in 1..tree.high:
    let inode = tree[i]
    if inode.level > stack.len:
      # Child.
      stack.add nnode
    elif inode.level == stack.len:
      # Sibling.
      stack[^1].children.add nnode
    else:
      # Branch terminated.
      while inode.level < stack.len:
        stack[^1].children.add nnode
        nnode = stack.pop()
      stack[^1].children.add nnode

    nnode = newNNode(inode.value)

  # Empty the stack.
  while stack.len > 0:
    stack[^1].children.add nnode
    nnode = stack.pop()

  result = nnode


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  echo "Displaying tree built using nested structure:"
  let nestedTree = newNNode("RosettaCode")
  let rocks = newNNode("rocks")
  rocks.add newNNode("code"), newNNode("comparison"), newNNode("wiki")
  let mocks = newNNode("mocks", newNNode("trolling"))
  nestedTree.add rocks, mocks
  echo nestedTree

  echo "Displaying tree converted to indented structure:"
  let indentedTree = nestedTree.toIndented
  echo indentedTree

  echo "Displaying tree converted back to nested structure:"
  echo indentedTree.toNested

  echo "Are they equal? ", if $nestedTree == $indentedTree.toNested: "yes" else: "no"
