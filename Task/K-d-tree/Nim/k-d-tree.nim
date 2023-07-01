type

  Point[Dim: static Natural; T: SomeNumber] = array[Dim, T]

  KdNode[Dim: static Natural; T: SomeNumber] = ref object
    x: Point[Dim, T]
    left, right: KdNode[Dim, T]


func toKdNodes[N, Dim: static Natural; T](a: array[N, array[Dim, T]]): array[N, KdNode[Dim, T]] =
  ## Create an array of KdNodes from an array of list of numerical values.
  for i in 0..<N:
    result[i] = KdNode[Dim, T](x: a[i])


func dist(a, b: Point): Point.T =
  ## Return the squared distance between two points.
  for i in 0..<Point.Dim:
    let t = a[i] - b[i]
    result += t * t


func findMedian(nodes: openArray[KdNode]; slice: Slice; idx: Natural): int =
  ## Return the index of the median node in a list of nodes.
  ## The list is defined by the full list of nodes and an slice.

  var first = slice.a
  var last = slice.b
  if last < first: return -1
  if last == first: return first

  let md = first + (last - first + 1) div 2

  while true:
    let pivot = nodes[md].x[idx]

    swap nodes[md].x, nodes[last].x
    var store = first
    for i in first..last:
      if nodes[i].x[idx] < pivot:
        if i != store:
          swap nodes[i].x, nodes[store].x
        inc store
    swap nodes[store].x, nodes[last].x

    if nodes[store].x[idx] == nodes[md].x[idx]:
      return md

    if store > md:
      last = store
    else:
      first = store


func makeTree(nodes: openArray[KdNode]; slice: Slice; idx: Natural = 0): KdNode =
  ## Build a tree from a list of nodes. Return the root of the tree.

  if slice.b < slice.a: return nil

  let n = nodes.findMedian(slice, idx)
  if n < 0: return nil

  let idx = (idx + 1) mod result.Dim
  nodes[n].left = nodes.makeTree(slice.a..<n, idx)
  nodes[n].right = nodes.makeTree((n + 1)..slice.b, idx)
  result = nodes[n]


func nearest(root,: KdNode; point: Point; idx: Natural;
             best: var KdNode; bestDist: var root.T; nVisited: var int) =
  ## Return the node of a tree which is the nearest to a given point.

  if root.isNil: return

  let d = dist(root.x, point)
  let dx = root.x[idx] - point[idx]
  inc nVisited

  if best.isNil or d < bestDist:
    bestDist = d
    best = root

  if bestDist == 0: return

  let idx = (idx + 1) mod root.Dim

  nearest(if dx > 0: root.left else: root.right, point, idx, best, bestDist, nVisited)
  if dx * dx >= bestDist: return
  nearest(if dx > 0: root.right else: root.left, point, idx, best, bestDist, nVisited)


#———————————————————————————————————————————————————————————————————————————————————————————————————


when isMainModule:

  import math, random, strformat


  proc displayResult(title: string; thisPt: Point;
                     found: KdNode; bestDist: thisPt.T; nVisited: int) =
    echo title & ':'
    echo &"  Searching for {thisPt}"
    echo &"  Found {found.x}, dist = {sqrt(float(bestDist)):.5f}"
    echo &"  Seen {nVisited} nodes."
    echo ""


  proc initRandom(point: var Point) =
    for item in point.mitems:
      item = rand(1.0)


  proc runSmallTest() =

    let
      wp = [[2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2]].toKdNodes()
      #thisPt = newPoint([9, 2])
      thisPt = Point([9, 2])
      root = wp.makeTree(0..wp.high)

    var
      found: KdNode[root.Dim, root.T]
      bestDist = root.T(0)
      nVisited = 0

    root.nearest(thisPt, 0, found, bestDist, nVisited)
    displayResult("WP tree", thisPt, found, bestDist, nVisited)


  proc runBigTest() =

    const N = 1_000_000
    const TestRuns = 100_000

    randomize()

    var bigTree: array[N, KdNode[3, float]]
    for node in bigTree.mitems:
      new(node)
      node.x.initRandom()

    let root = bigTree.makeTree(0..bigTree.high)
    var thisPt: Point[3, float]
    thisPt.initRandom()

    var
      found: KdNode[3, float]
      bestDist = 0.0
      nVisited = 0

    root.nearest(thisPt, 0, found, bestDist, nVisited)
    displayResult("Big Tree", thisPt, found, bestDist, nVisited)

    var sum = 0
    for _ in 0..<TestRuns:
      found = nil
      nVisited = 0
      thisPt.initRandom()
      root.nearest(thisPt, 0, found, bestDist, nVisited)
      sum += nVisited

    echo "Big tree:"
    echo &"  Visited {sum} nodes for {TestRuns} random searches ({sum / TestRuns:.2f} per lookup)."

runSmallTest()
runBigTest()
