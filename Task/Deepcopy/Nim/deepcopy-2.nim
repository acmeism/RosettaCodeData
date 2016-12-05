import queues, sequtils

type
  Node[T] = ref TNode[T]
  TNode[T] = object
    data: T
    left, right: Node[T]

proc newNode[T](data: T; left, right: Node[T] = nil): Node[T] =
  Node[T](data: data, left: left, right: right)

proc preorder[T](n: Node[T]): seq[T] =
  if n == nil: @[]
  else: @[n.data] & preorder(n.left) & preorder(n.right)

var tree = 1.newNode(
             2.newNode(
               4.newNode(
                 7.newNode),
               5.newNode),
             3.newNode(
               6.newNode(
                 8.newNode,
                 9.newNode)))

var tree2: Node[int]
tree2.deepCopy tree
tree2.data = 10
tree2.left.data = 20
tree2.right.left.data = 90

echo "Tree2:"
echo preorder tree2

echo "Tree:"
echo preorder tree
