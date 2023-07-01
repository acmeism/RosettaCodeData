import sequtils, strutils

type
  Kind = enum kValue, kList
  Node = ref object
    case kind: Kind
    of kValue: value: int
    of kList: list: seq[Node]


proc newTree(s: varargs[int]): Node =
  ## Build a tree from a list of level values.
  var level = 1
  result = Node(kind: kList)
  var stack = @[result]
  for n in s:
    if n <= 0:
      raise newException(ValueError, "expected a positive integer, got " & $n)
    let node = Node(kind: kValue, value: n)
    if n < level:
      # Unstack lists.
      stack.setLen(n)
      level = n
    else:
      while n > level:
        # Create intermediate lists.
        let newList = Node(kind: kList)
        stack[^1].list.add newList
        stack.add newList
        inc level
    # Add value.
    stack[^1].list.add node


proc `$`(node: Node): string =
  ## Display a tree using a nested lists representation.
  if node.kind == kValue: $node.value
  else: '[' & node.list.mapIt($it).join(", ") & ']'


for list in [newSeq[int](),   # Empty list (== @[]).
             @[1, 2, 4],
             @[3, 1, 3, 1],
             @[1, 2, 3, 1],
             @[3, 2, 1, 3],
             @[3, 3, 3, 1, 1, 3, 3, 3]]:
  echo ($list).align(25), " → ", newTree(list)
