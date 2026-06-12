import std/[algorithm, math, random]

template XY(row, col, width: int): int =
  col + row * width

template XYZ(page, row, col, height, width: int): int =
  XY(XY(page, row, height), col, width)

const Blocks = @[byte 0, 0, 0,
                      0, 0, 0,
                      0, 0, 0,
                      0, 0, 0,
                      1, 1, 1,
                      0, 1, 0,
                      0, 1, 0,
                      0, 1, 1,
                      0, 1, 0,
                      0, 1, 0,
                      1, 1, 1,
                      0, 0, 0,
                      0, 1, 0,
                      1, 1, 0,
                      0, 1, 0]


proc wfc(blocks: seq[byte]; bdim: (int, int, int); tdim: (int, int); ): seq[byte] =
  let (td0, td1) = tdim
  let n = td0 * td1
  var adj = newSeq[int](n * 4)    # Indices in R of the four adjacent blocks.

  for i in 0..<td0:
    for j in 0..<td1:
      adj[XYZ(i, j, 0, td1, 4)]= XY(floorMod(i-1, td0), floorMod(j, td1), td1)
      adj[XYZ(i, j, 1, td1, 4)]= XY(floorMod(i, td0), floorMod(j-1, td1), td1)
      adj[XYZ(i, j, 2, td1, 4)]= XY(floorMod(i, td0), floorMod(j+1, td1), td1)
      adj[XYZ(i, j, 3, td1, 4)]= XY(floorMod(i+1, td0), floorMod(j, td1), td1)

  let (bd0, bd1, bd2) = bdim

  var horz = newSeq[byte](bd0 * bd0)
  for i in 0..<bd0:
    for j in 0..<bd0:
      horz[XY(i, j, bd0)]= 1
      for k in 0..<bd1:
        if blocks[XYZ(i, k, 0, bd1, bd2)] != blocks[XYZ(j, k, bd2-1, bd1, bd2)]:
          horz[XY(i, j, bd0)]= 0

  var vert = newSeq[byte](bd0 * bd0)
  for i in 0..<bd0:
    for j in 0..<bd0:
      vert[XY(i, j, bd0)]= 1
      for k in 0..<bd2:
        if blocks[XYZ(i, 0, k, bd1, bd2)] != blocks[XYZ(j, bd1-1, k, bd1, bd2)]:
          vert[XY(i, j, bd0)]= 0
          break

  var allow = newSeq[byte](4 * (bd0 + 1) * bd0)
  allow.fill(1)
  for i in 0..<bd0:
    for j in 0..<bd0:
      allow[XYZ(0, i, j, bd0+1, bd0)] = vert[XY(j, i, bd0)]
      allow[XYZ(1, i, j, bd0+1, bd0)] = horz[XY(j, i, bd0)]
      allow[XYZ(2, i, j, bd0+1, bd0)] = horz[XY(i, j, bd0)]
      allow[XYZ(3, i, j, bd0+1, bd0)] = vert[XY(i, j, bd0)]

  var
    todo = newSeq[int](n)
    wave = newSeq[byte](n * bd0)
    entropy = newSeq[int](n)
    indices = newSeq[int](n)
    possible = newSeq[int](bd0)
  var r = newSeq[int](n)
  r.fill(bd0)
  while true:
    var c = 0
    for i in 0..<n:
      if bd0 == r[i]:
        todo[c]= i
        inc c
    if c == 0: break
    var min = bd0
    for i in 0..<c:
      entropy[i] = 0
      for j in 0..<bd0:
        let val = allow[XYZ(0, r[adj[XY(todo[i],0,4)]], j, bd0+1, bd0)] and
                  allow[XYZ(1, r[adj[XY(todo[i],1,4)]], j, bd0+1, bd0)] and
                  allow[XYZ(2, r[adj[XY(todo[i],2,4)]], j, bd0+1, bd0)] and
                  allow[XYZ(3, r[adj[XY(todo[i],3,4)]], j, bd0+1, bd0)]
        wave[XY(i, j, bd0)] = val
        entropy[i] += val.int
      if entropy[i] < min: min = entropy[i]
    if min == 0:
      r.setLen(0)
      break
    var d = 0
    for i in 0..<c:
      if min == entropy[i]:
        indices[d] = i
        inc d
    var ndx = indices[rand(d - 1)]
    let ind = ndx * bd0
    d = 0
    for i in 0..<bd0:
      if wave[ind + i] != 0:
        possible[d] = i
        inc d
    r[todo[ndx]] = possible[rand(d - 1)];

  if r.len == 0: return @[]
  result = newSeq[byte]((1 + td0 * (bd1 - 1)) * (1 + td1 * (bd2 - 1)))
  for i0 in 0..<td0:
    for i1 in 0..<bd1:
      for j0 in 0..<td1:
        for j1 in 0..<bd2:
          result[XY(XY(j0, j1, bd2-1), XY(i0, i1, bd1-1), 1+td1*(bd2-1))] =
                        blocks[XYZ(r[XY(i0, j0, td1)], i1, j1, bd1, bd2)]

const BDims = (5, 3, 3)
const Size = (8, 8)
randomize()
let tile = wfc(Blocks, BDims, Size)
if tile.len == 0: quit QuitSuccess
for i in 0..16:
  for j in 0..16:
    stdout.write " #"[tile[XY(i, j, 17)]], ' '
  echo()
