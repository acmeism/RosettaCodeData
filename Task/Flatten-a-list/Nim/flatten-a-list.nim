type
  TreeList[T] = object
    case isLeaf: bool
    of true: data: T
    of false: list: seq[TreeList[T]]

proc L[T](list: varargs[TreeList[T]]): TreeList[T] =
  for x in list:
    result.list.add x

proc N[T](data: T): TreeList[T] =
  TreeList[T](isLeaf: true, data: data)

proc flatten[T](n: TreeList[T]): seq[T] =
  if n.isLeaf: result = @[n.data]
  else:
    for x in n.list:
      result.add flatten x

var x = L(L(N 1), N 2, L(L(N 3, N 4), N 5), L(L(L[int]())), L(L(L(N 6))), N 7, N 8, L[int]())
echo flatten(x)
