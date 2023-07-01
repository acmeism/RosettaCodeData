# Dijkstra algorithm.

from algorithm import reverse
import sets
import strformat
import tables

type
  Edge = tuple[src, dst: string; cost: int]
  Graph = object
    vertices: HashSet[string]
    neighbours: Table[string, seq[tuple[dst: string, cost: float]]]

#---------------------------------------------------------------------------------------------------

proc initGraph(edges: openArray[Edge]): Graph =
  ## Initialize a graph from an edge list.
  ## Use floats for costs in order to compare to Inf value.

  for (src, dst, cost) in edges:
    result.vertices.incl(src)
    result.vertices.incl(dst)
    result.neighbours.mgetOrPut(src, @[]).add((dst, cost.toFloat))

#---------------------------------------------------------------------------------------------------

proc dijkstraPath(graph: Graph; first, last: string): seq[string] =
  ## Find the path from "first" to "last" which minimizes the cost.

  var dist = initTable[string, float]()
  var previous = initTable[string, string]()
  var notSeen = graph.vertices
  for vertex in graph.vertices:
    dist[vertex] = Inf
  dist[first] = 0

  while notSeen.card > 0:
    # Search vertex with minimal distance.
    var vertex1: string
    var mindist = Inf
    for vertex in notSeen:
      if dist[vertex] < mindist:
        vertex1 = vertex
        mindist = dist[vertex]
    if vertex1 == last:
      break
    notSeen.excl(vertex1)
    # Find shortest paths to neighbours.
    for (vertex2, cost) in graph.neighbours.getOrDefault(vertex1):
      if vertex2 in notSeen:
        let altdist = dist[vertex1] + cost
        if altdist < dist[vertex2]:
          # Found a shorter path to go to vertex2.
          dist[vertex2] = altdist
          previous[vertex2] = vertex1    # To go to vertex2, go through vertex1.

  # Build the path.
  var vertex = last
  while vertex.len > 0:
    result.add(vertex)
    vertex = previous.getOrDefault(vertex)
  result.reverse()

#---------------------------------------------------------------------------------------------------

proc printPath(path: seq[string]) =
  ## Print a path.
  stdout.write(fmt"Shortest path from '{path[0]}' to '{path[^1]}': {path[0]}")
  for i in 1..path.high:
    stdout.write(fmt" → {path[i]}")
  stdout.write('\n')

#---------------------------------------------------------------------------------------------------

let graph = initGraph([("a", "b", 7), ("a", "c", 9), ("a", "f", 14),
                       ("b", "c", 10), ("b", "d", 15), ("c", "d", 11),
                       ("c", "f", 2), ("d", "e", 6), ("e", "f", 9)])
printPath(graph.dijkstraPath("a", "e"))
printPath(graph.dijkstraPath("a", "f"))
