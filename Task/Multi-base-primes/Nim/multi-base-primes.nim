import math, sequtils, strutils

const
  MaxDepth = 6
  Max = 36^MaxDepth - 1  # Max value for MaxDepth digits in base 36.
  Digits = "0123456789abcdefghijklmnopqrstuvwxyz"

# Sieve of Erathostenes.
var composite: array[1..(Max div 2), bool]    # Only odd numbers.
for i in 1..composite.high:
  let n = 2 * i + 1
  let n2 = n * n
  if n2 > Max: break
  if not composite[i]:
    for k in countup(n2, Max, 2 * n):
      composite[k shr 1] = true

template isPrime(n: int): bool =
  if n <= 1: false
  elif (n and 1) == 0: n == 2
  else: not composite[n shr 1]

type Context = object
  indices: seq[int]
  mostBases: int
  maxStrings: seq[tuple[indices, bases: seq[int]]]

func initContext(depth: int): Context =
  result.indices.setLen(depth)
  result.mostBases = -1


proc process(ctx: var Context) =
  let minBase = max(2, max(ctx.indices) + 1)
  if 37 - minBase < ctx.mostBases: return

  var bases: seq[int]
  for b in minBase..36:
    var n = 0
    for i in ctx.indices:
      n = n * b + i
    if n.isPrime: bases.add b

  var count = bases.len
  if count > ctx.mostBases:
    ctx.mostBases = count
    ctx.maxStrings = @{ctx.indices: bases}
  elif count == ctx.mostBases:
    ctx.maxStrings.add (ctx.indices, bases)


proc nestedFor(ctx: var Context; length, level: int) =
  if level == ctx.indices.len:
    ctx.process()
  else:
    ctx.indices[level] = if level == 0: 1 else: 0
    while ctx.indices[level] < length:
      ctx.nestedFor(length, level + 1)
      inc ctx.indices[level]


for depth in 1..MaxDepth:
  var ctx = initContext(depth)
  ctx.nestedFor(Digits.len, 0)
  echo depth, " character strings which are prime in most bases: ", ctx.maxStrings[0].bases.len
  for m in ctx.maxStrings:
    echo m.indices.mapIt(Digits[it]).join(), " → ", m[1].join(" ")
  echo()
