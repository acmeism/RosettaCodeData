import std/[algorithm, sequtils, sets, strutils, tables]

type StringSet = HashSet[string]

const Empty = initHashSet[string]()

proc bronKerbosch(r: var StringSet;               # Current clique.
                  p: var StringSet;               # Potential candidates to expand the clique.
                  x: var StringSet;               # Vertices already processed.
                  g: Table[string, StringSet];    # Graph represented as an adjacency list.
                  cliques: var seq[seq[string]]   # List to store all maximal cliques.
                 ) =

  if card(p) == 0 and card(x) == 0:
    if card(r) > 2:
      let clique = sorted(toSeq(r.items))
      cliques.add clique
    return

  # Select a pivot vertex from P ∪ X with the maximum degree.
  var pivot = ""
  for v in p + x:
    let n = g.getOrDefault(v, Empty).len
    if n > pivot.len: pivot = v

  # Candidates are vertices in "p" that are not neighbors of the pivot.
  let candidates = p - g[pivot]

  for v in candidates:
    # New clique including vertex "v".
    var newR = r
    newR.incl v
    # New potential candidates are neighbors of "v" in "p".
    let neighbors = g[v]
    var newP = p * neighbors
    # New excluded vertices are neighbors of "v" in "x".
    var newX = x * neighbors
    # Recursive call with updated sets.
    bronKerbosch(newR, newP, newX, g, cliques)
    # Move vertex "v" from "p" to "x".
    p.excl v
    x.incl v


when isMainModule:

  proc cmp(a, b: seq[string]): int =
    ## Comparison procedure to use for sorting.
    result = cmp(a.len, b.len)
    if result == 0:
      for i in 0..a.len:
        result = cmp(a[i], b[i])
        if result != 0: return

  # Define the input edges as a list of tuples.
  let input = [("a", "b"), ("b", "a"), ("a", "c"), ("c", "a"),
               ("b", "c"), ("c", "b"), ("d", "e"), ("e", "d"),
               ("d", "f"), ("f", "d"), ("e", "f"), ("f", "e")]

  # Build the graph as an adjacency list.
  var graph: Table[string, StringSet]
  for (t1, t2) in input:
    graph.mgetOrPut(t1, initHashSet[string]()).incl t2

  # Initialize "r", "p", "x".
  var r, x: StringSet
  var p = toSeq(graph.keys).toHashSet()

  # Initialize list to store cliques.
  var cliques: seq[seq[string]]

  # Execute the Bron-Kerbosch algorithm.
  bronKerbosch(r, p, x, graph, cliques)

  # Sort the cliques for consistent output.
  cliques.sort(cmp)

  # Print each clique.
  for clique in cliques:
    echo clique.join(", ")
