import math, sequtils, strutils
randomize()

template newSeqWith(len: int, init: expr): expr =
  var result {.gensym.} = newSeq[type(init)](len)
  for i in 0 .. <len:
    result[i] = init
  result

iterator randomCover[T](xs: openarray[T]): T =
  var js = toSeq 0..xs.high
  for i in countdown(js.high, 0):
    let j = random(i + 1)
    swap(js[i], js[j])
  for j in js:
    yield xs[j]

const
  w = 14
  h = 10

var
  vis = newSeqWith(h, newSeq[bool](w))
  hor = newSeqWith(h+1, newSeqWith(w, "+---"))
  ver = newSeqWith(h, newSeqWith(w, "|   ") & "|")

proc walk(x, y) =
  vis[y][x] = true
  for p in [[x-1,y], [x,y+1], [x+1,y], [x,y-1]].randomCover:
    if p[0] notin 0 .. <w or p[1] notin 0 .. <h or vis[p[1]][p[0]]: continue
    if p[0] == x: hor[max(y, p[1])][x] = "+   "
    if p[1] == y: ver[y][max(x, p[0])] = "    "
    walk p[0], p[1]

walk random(0..w), random(0..h)
for a,b in zip(hor, ver & @[""]).items:
  echo join(a & "+\n" & b)
