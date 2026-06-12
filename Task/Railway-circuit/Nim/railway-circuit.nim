import algorithm, sequtils, strformat, strutils, sugar, tables

type

  Direction {.pure.} = enum Left = (-1, "L"), Straight = (0, "S"), Right = (1, "R")

  PermutationsGen = object
    indices: seq[int]
    choices: seq[Direction]
    carry: int


func initPermutationsGen(numPositions: int; choices: seq[Direction]): PermutationsGen =
  result.indices.setLen(numPositions)
  result.choices = choices


func next(pg: var PermutationsGen): seq[Direction] =
  pg.carry = 1
  # The generator skips the first index, so the result will always start
  # with a right turn (0) and we avoid clockwise/counter-clockwise
  # duplicate solutions.
  var i = 1
  while i < pg.indices.len and pg.carry > 0:
    pg.indices[i] += pg.carry
    pg.carry = 0
    if pg.indices[i] == pg.choices.len:
      pg.carry = 1
      pg.indices[i] = 0
    inc i
  result.setLen(pg.indices.len)
  for i, idx in pg.indices:
    result[i] = pg.choices[idx]


template hasNext(pg: PermutationsGen): bool = pg.carry != 1


func normalize(tracks: seq[Direction]): string =
  let length = tracks.len
  var a = collect(newSeq, for val in tracks: $val).join()

  # Rotate the array and find the lexicographically lowest order
  # to allow the hashmap to weed out duplicate solutions.
  result = a
  for _ in 2..length:
    a.rotateLeft(1)
    if a < result: result = a


func fullCircleStraight(tracks: seq[Direction]; nStraight: int): bool =
  if nStraight == 0: return true

  # Do we have the requested number of straight tracks?
  if tracks.count(Straight) != nStraight: return false

  # Check symmetry of straight tracks: i and i + 6, i and i + 4.
  var straight: array[12, int]
  var i, idx = 0
  while i < tracks.len and idx >= 0:
    if tracks[i] == Straight: inc straight[idx mod 12]
    idx += ord(tracks[i])
    inc i
  result = true
  for i in 0..5:
    if straight[i] != straight[i + 6]:
      result = false
      break
  if result: return
  result = true
  for i in 0..7:
    if straight[i] != straight[i + 4]: return false


func fullCircleRight(tracks: seq[Direction]): bool =
  # All tracks need to add up to a multiple of 360.
  var s = 0
  for dir in tracks: s += ord(dir) * 30
  if s mod 360 != 0: return false

  # Check symmetry of right turns: i and i + 6, i and i + 4.
  var rTurns: array[12, int]
  var i, idx = 0
  while i < tracks.len and idx >= 0:
    if tracks[i] == Right: inc rTurns[idx mod 12]
    idx += ord(tracks[i])
    inc i
  result = true
  for i in 0..5:
    if rTurns[i] != rTurns[i + 6]:
      result = false
      break
  if result: return
  result = true
  for i in 0..7:
    if rTurns[i] != rTurns[i + 4]: return false


func getPermutationsGen(nCurved, nStraight: int): PermutationsGen =
  doAssert (nCurved + nStraight - 12) mod 4 == 0, "input must be 12 + k * 4"
  let trackTypes =
    if nStraight == 0: @[Right, Left]
    elif nCurved == 12: @[Right, Straight]
    else: @[Right, Left, Straight]
  result = initPermutationsGen(nCurved + nStraight, trackTypes)


proc report(sol: Table[string, seq[Direction]]; nCurved, nStraight: int) =
  let length = sol.len
  let plural = if length > 1: "s" else: ""
  echo &"\n{length} solution{plural} for C{nCurved},{nStraight}"
  if nCurved <= 20:
    for track in sol.values:
      echo track.join(" ")

proc circuits(nCurved, nStraight: Natural) =
  var solutions: Table[string, seq[Direction]]
  var gen = getPermutationsGen(nCurved, nStraight)
  while gen.hasNext():
    let tracks = gen.next()
    if not fullCircleStraight(tracks, nStraight): continue
    if not fullCircleRight(tracks): continue
    solutions[tracks.normalize()] = tracks
  report(solutions, nCurved, nStraight)

for n in countup(12, 36, 4):
  circuits(n, 0)
circuits(12, 4)
