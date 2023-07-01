type
  Vertex = int
  Graph = seq[seq[Vertex]]
  Scc = seq[Vertex]

func korasaju(g: Graph): seq[Scc] =

  var
    size = g.len
    visited = newSeq[bool](size)        # All false by default.
    l = newSeq[Vertex](size)            # All zero by default.
    x = size                            # Index for filling "l" in reverse order.
    t = newSeq[seq[Vertex]](size)       # Transposed graph.
    c = newSeq[Vertex](size)            # Used for component assignment.

  func visit(u: Vertex) =
    if not visited[u]:
      visited[u] = true
      for v in g[u]:
        visit(v)
        t[v].add(u)   # Construct transposed graph.
      dec x
      l[x] = u

  func assign(u, root: Vertex) =
    if visited[u]:
      # Repurpose visited to mean 'unassigned'.
      visited[u] = false
      c[u] = root
      for v in t[u]: v.assign(root)

  for u in 0..g.high: u.visit()
  for u in l: u.assign(u)

  # Build list of strongly connected components.
  var prev = -1
  for v1, v2 in c:
    if v2 != prev:
      prev = v2
      result.add @[]
    result[^1].add v1


when isMainModule:
  let g = @[@[1], @[2], @[0], @[1, 2, 4], @[3, 5], @[2, 6], @[5], @[4, 6, 7]]
  for scc in korasaju(g): echo $scc
