import random


type
  BoolArray  = array[30, bool]
  Symbols    = array[bool, char]


proc neighbours(map: BoolArray, i: int): int =
  if i > 0:             inc(result, int(map[i - 1]))
  if i + 1 < len(map):  inc(result, int(map[i + 1]))

proc print(map: BoolArray, symbols: Symbols) =
  for i in map: write(stdout, symbols[i])
  write(stdout, "\l")

proc randomMap: BoolArray =
  randomize()
  for i in mitems(result): i = rand([true, false])


const
  num_turns = 20
  symbols   = ['_', '#']

  T = true
  F = false

var map =
  [F, T, T, T, F, T, T, F, T, F, T, F, T, F, T,
    F, F, T, F, F, F, F, F, F, F, F, F, F, F, F]

# map = randomMap()  # uncomment for random start

print(map, symbols)

for _ in 0 ..< num_turns:
  var map2 = map

  for i, v in pairs(map):
    map2[i] =
      if v: neighbours(map, i) == 1
      else: neighbours(map, i) == 2

  print(map2, symbols)

  if map2 == map: break
  map = map2
