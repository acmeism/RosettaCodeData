const S = 10

type

  NodeKind = enum nodeFree, nodeA, nodeB

  Node = object
    v: float
    fixed: NodeKind

  Mesh[H, W: static int] = array[H, array[W, Node]]


func setBoundary(m: var Mesh) =
  m[1][1].v =  1.0
  m[1][1].fixed = nodeA
  m[6][7].v = -1.0
  m[6][7].fixed = nodeB


func calcDiff[H, W: static int](m,: Mesh[H, W]; d: var Mesh[H, W]): float =
  for i in 0..<H:
    for j in 0..<W:
      var v = 0.0
      var n = 0
      if i > 0:
        v += m[i - 1][j].v
        inc n
      if j > 0:
        v += m[i][j - 1].v
        inc n
      if i + 1 < m.H:
        v += m[i + 1][j].v
        inc n
      if j + 1 < m.W:
        v += m[i][j + 1].v
        inc n
      v = m[i][j].v - v / n.toFloat
      d[i][j].v = v
      if m[i][j].fixed == nodeFree:
        result += v * v


func iter[H, W: static int](m: var Mesh[H, W]): float =
  var
    d: Mesh[H, W]
    cur: array[NodeKind, float]
    diff = 1e10

  while diff > 1e-24:
    m.setBoundary()
    diff = calcDiff(m, d)
    for i in 0..<H:
      for j in 0..<W:
        m[i][j].v -= d[i][j].v

  for i in 0..<H:
    for j in 0..<W:
      var k = 0
      if i != 0: inc k
      if j != 0: inc k
      if i < m.H - 1: inc k
      if j < m.W - 1: inc k
      cur[m[i][j].fixed] += d[i][j].v * k.toFloat

  result = (cur[nodeA] - cur[nodeB]) / 2


when isMainModule:

  var mesh: Mesh[S, S]
  let r = 2 / mesh.iter()
  echo "R = ", r
