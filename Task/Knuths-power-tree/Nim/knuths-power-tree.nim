import tables
import bignum

type

  Id = Natural    # Node identifier (= exponent value).

  Tree = object
    parents: Table[Id, Id]  # Mapping node id -> parent node id.
    lastLevel: seq[Id]      # List of node ids in current last level.


func initTree(): Tree =
  ## Return an initialized tree.
  const Root = Id(1)
  Tree(parents: {Root: Id(0)}.toTable, lastLevel: @[Root])


func path(tree: var Tree; id: Id): seq[Id] =
  ## Return the path to node with given id.

  if id == 0: return

  while id notin tree.parents:
    # Node "id" not yet present in the tree: build a new level.
    var newLevel: seq[Id]
    for x in tree.lastLevel:
      for y in tree.path(x):
        let newId = x + y
        if newId in tree.parents: break   # Node already created.
        # Create a new node.
        tree.parents[newId] = x
        newLevel.add newId
    tree.lastLevel = move(newLevel)

  # Node path is the concatenation of parent node path and node id.
  result = tree.path(tree.parents[id]) & id


func treePow[T: SomeNumber | Int](tree: var Tree; x: T; n: Natural): T =
  ## Compute x^n using the power tree.
  let one = when T is Int: newInt(1) else: T(1)
  var results = {0: one, 1: x}.toTable  # Intermediate and last results.
  var k = 0
  for i in tree.path(n):
    results[i] = results[i - k] * results[k]
    k = i
  return results[n]


proc showPow[T: SomeNumber | Int](tree: var Tree; x: T; n: Natural) =
  echo n, " → ", ($tree.path(n))[1..^1]
  let result = tree.treePow(x, n)
  echo x, "^", n, " = ", result


when isMainModule:

  var tree = initTree()
  for n in 0..17: tree.showPow(2, n)
  echo ""
  tree.showPow(1.1, 81)
  echo ""
  tree.showPow(newInt(3), 191)
