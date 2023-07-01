import strutils, sugar

type Tree[T] = ref object
  value: T
  left, right: Tree[T]


proc newTree[T](value = default(T)): Tree[T] =
  ## Create a tree with a single node with the given value.
  Tree[T](value: value)


proc map[T, U](tree: Tree[T]; f: (T) -> U): Tree[U] =
  ## Apply function "f" to each element of a tree, building
  ## another tree.
  result = newTree[U](f(tree.value))
  if not tree.left.isNil:
    result.left = tree.left.map(f)
  if not tree.right.isNil:
    result.right = tree.right.map(f)


proc print(tree: Tree; indent = 0) =
  ## Print a tree.
  let start = repeat(' ', indent)
  echo start, "value: ", tree.value
  if tree.left.isNil:
    echo start, "  nil"
  else:
    print(tree.left, indent + 2)
  if tree.right.isNil:
    echo start, "  nil"
  else:
    print(tree.right, indent + 2)


when isMainModule:

  echo "Initial tree:"
  var tree = newTree[int](5)
  tree.left = newTree[int](2)
  tree.right = newTree[int](7)
  print(tree)

  echo ""
  echo "Tree created by applying a function to each node:"
  let tree1 = tree.map((x) => 1 / x)
  print(tree1)
