import algorithm, math, sequtils, strutils, tables

const
  # First generator.
  a1 = [int64 0, 1403580, -810728]
  m1: int64 = 2^32 - 209
  # Second generator.
  a2 = [int64 527612, 0, -1370589]
  m2: int64 = 2^32 - 22853

  d = m1 + 1

type MRG32k3a = object
  x1: array[3, int64]   # List of three last values of gen #1.
  x2: array[3, int64]   # List of three last values of gen #2.


func seed(gen: var MRG32k3a; seedState: int64) =
  assert seedState in 1..<d
  gen.x1 = [seedState, 0, 0]
  gen.x2 = [seedState, 0, 0]

func nextInt(gen: var MRG32k3a): int64 =
  let x1i = floormod(a1[0] * gen.x1[0] + a1[1] * gen.x1[1] + a1[2] * gen.x1[2], m1)
  let x2i = floormod(a2[0] * gen.x2[0] + a2[1] * gen.x2[1] + a2[2] * gen.x2[2], m2)
  # In version 1.4, the following two lines doesn't work.
  # gen.x1 = [x1i, gen.x1[0], gen.x1[1]]    # Keep last three.
  # gen.x2 = [x2i, gen.x2[0], gen.x2[1]]    # Keep last three.
  gen.x1[2] = gen.x1[1]; gen.x1[1] = gen.x1[0]; gen.x1[0] = x1i
  gen.x2[2] = gen.x2[1]; gen.x2[1] = gen.x2[0]; gen.x2[0] = x2i
  result = floormod(x1i - x2i, m1) + 1

func nextFloat(gen: var MRG32k3a): float =
  gen.nextInt().float / d.float

when isMainModule:
  var gen: MRG32k3a

  gen.seed(1234567)
  for _ in 1..5:
    echo gen.nextInt()

  echo ""
  gen.seed(987654321)
  var counts: CountTable[int]
  for _ in 1..100_000:
    counts.inc int(gen.nextFloat() * 5)
  echo sorted(toSeq(counts.pairs)).mapIt($it[0] & ": " & $it[1]).join(", ")
