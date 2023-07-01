import sequtils, strformat

type
  Weight = tuple[src, dest, value: int]
  Weights = seq[Weight]


#---------------------------------------------------------------------------------------------------

proc printResult(dist: seq[seq[float]]; next: seq[seq[int]]) =

  echo "pair     dist    path"
  for i in 0..next.high:
    for j in 0..next.high:
      if i != j:
        var u = i + 1
        let v = j + 1
        var path = fmt"{u} -> {v}    {dist[i][j].toInt:2d}     {u}"
        while true:
          u = next[u-1][v-1]
          path &= fmt" -> {u}"
          if u == v: break
        echo path


#---------------------------------------------------------------------------------------------------

proc floydWarshall(weights: Weights; numVertices: Positive) =

  var dist = repeat(repeat(Inf, numVertices), numVertices)
  for w in weights:
    dist[w.src - 1][w.dest - 1] = w.value.toFloat

  var next = repeat(newSeq[int](numVertices), numVertices)
  for i in 0..<numVertices:
    for j in 0..<numVertices:
      if i != j:
        next[i][j] = j + 1

  for k in 0..<numVertices:
    for i in 0..<numVertices:
      for j in 0..<numVertices:
        if dist[i][j] > dist[i][k] + dist[k][j]:
          dist[i][j] = dist[i][k] + dist[k][j]
          next[i][j] = next[i][k]

  printResult(dist, next)


#———————————————————————————————————————————————————————————————————————————————————————————————————

let weights: Weights = @[(1, 3, -2), (2, 1, 4), (2, 3, 3), (3, 4, 2), (4, 2, -1)]
let numVertices = 4

floydWarshall(weights, numVertices)
