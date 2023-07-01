import std/[sequtils, strformat, strutils]

const Gmooh = """
.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........""".split("\n")

const
  Width  = Gmooh[0].len
  Height = Gmooh.len
  Infinity = int.high
  None = -1

type
  Pyx = tuple[y, x: int]
  FloydWarshall = object
    dist, next: seq[seq[int]]
    pmap: seq[Pyx]

const D: array[8, Pyx] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]

proc `$`(pyx: Pyx): string =
  &"({pyx.y}, {pyx.x})"

func fwPath(fw: FloydWarshall; u, v: int): string =
  var u = u
  if fw.next[u][v] != None:
    var path = @[$fw.pmap[u]]
    while u != v:
      u = fw.next[u][v]
      path.add $fw.pmap[u]
    result = path.join(" → ")

proc showPath(fw: FloydWarshall; u, v: int) =
  echo &"{fw.pmap[u]} → {fw.pmap[v]}   {fw.dist[u][v]:>2}   {fw.fwPath(u, v)}"

proc floydWarshall =
  var fw: FloydWarshall
  var point = 0
  var weights: seq[Pyx]
  var points = newSeqWith(Height, newSeq[int](Width))
  # First, number the points...
  for x in 0..<Width:
    for y in 0..<Height:
      if Gmooh[y][x] >= '0':
        points[y][x] = point
        inc point
        fw.pmap.add (y, x)
  # ...and then a set of edges (all of which have a "weight" of one day).
  for x in 0..<Width:
    for y in 0..<Height:
      if Gmooh[y][x] > '0':
        let n = ord(Gmooh[y][x]) - ord('0')
        for (dy, dx) in D:
          let rx = x + n * dx
          let ry = y + n * dy
          if rx >= 0 and rx < Width and ry >= 0 and ry < Height and Gmooh[ry][rx] >= '0':
            weights.add (points[y][x], points[ry][rx])
  # Before applying Floyd-Warshall.
  let v = fw.pmap.len
  fw.dist = newSeqWith(v, repeat(Infinity, v))
  fw.next = newSeqWith(v, repeat(None, v))
  for (u, v) in weights:
    fw.dist[u][v] = 1   # The weight of the edge (u, v).
    fw.next[u][v] = v
  # Standard Floyd-Warshall implementation, with the optimization of avoiding
  # processing of self/infs, which surprisingly makes quite a noticeable difference.
  for k in 0..<v:
    for i in 0..<v:
      if i != k and fw.dist[i][k] != Infinity:
        for j in 0..<v:
          if j != i and j != k and fw.dist[k][j] != Infinity:
            let d  = fw.dist[i][k] + fw.dist[k][j]
            if d < fw.dist[i][j]:
              fw.dist[i][j] = d
              fw.next[i][j] = fw.next[i][k]
  fw.showPath(points[21][11], points[1][11])
  fw.showPath(points[1][11], points[21][11])

  var maxd = 0
  var mi, mj: int
  for i in 0..<v:
    for j in 0..<v:
      if j != i:
        let d = fw.dist[i][j]
        if d != Infinity and d > maxd:
          maxd = d
          mi = i
          mj = j
  echo "\nMaximum shortest distance:"
  fw.showPath(mi, mj)

floydWarshall()
