import sequtils, strutils, tables

type

  Node = ref object
    val: int
    index: int
    lowLink: int
    onStack: bool

  Nodes = seq[Node]

  DirectedGraph = object
    nodes: seq[Node]
    edges: Table[int, Nodes]


func initNode(n: int): Node =
  Node(val: n, index: -1, lowLink: -1, onStack: false)


func `$`(node: Node): string = $node.val


func tarjan(g: DirectedGraph): seq[Nodes] =
  var index = 0
  var s: seq[Node]
  var sccs: seq[Nodes]


  func strongConnect(v: Node) =

    # Set the depth index for "v" to the smallest unused index.
    v.index = index
    v.lowLink = index
    inc index
    s.add v
    v.onStack = true

    # Consider successors of "v".
    for w in g.edges[v.val]:
      if w.index < 0:
        # Successor "w" has not yet been visited; recurse on it.
        w.strongConnect()
        v.lowLink = min(v.lowLink, w.lowLink)
      elif w.onStack:
        # Successor "w" is in stack "s" and hence in the current SCC.
        v.lowLink = min(v.lowLink, w.index)

    # If "v" is a root node, pop the stack and generate an SCC.
    if v.lowLink == v.index:
      var scc: Nodes
      while true:
        let w = s.pop()
        w.onStack = false
        scc.add w
        if w == v: break
      sccs.add scc


  for v in g.nodes:
    if v.index < 0:
      v.strongConnect()
  result = move(sccs)


when isMainModule:

  let vs = toSeq(0..7).map(initNode)
  let es = {0: @[vs[1]],
            1: @[vs[2]],
            2: @[vs[0]],
            3: @[vs[1], vs[2], vs[4]],
            4: @[vs[5], vs[3]],
            5: @[vs[2], vs[6]],
            6: @[vs[5]],
            7: @[vs[4], vs[7], vs[6]]}.toTable
  var g = DirectedGraph(nodes: vs, edges: es)
  let sccs = g.tarjan()
  echo sccs.join("\n")
