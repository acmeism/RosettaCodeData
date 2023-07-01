import algorithm, sequtils, strutils, tables

const N = 6364136223846793005u64

type PCG32 = object
  inc: uint64
  state: uint64

func seed(gen: var PCG32; seedState, seedSequence: uint64) =
  gen.inc = seedSequence shl 1 or 1
  gen.state = (gen.inc + seedState) * N + gen.inc

func nextInt(gen: var PCG32): uint32 =
  let xs = uint32((gen.state shr 18 xor gen.state) shr 27)
  let rot = int32(gen.state shr 59)
  result = uint32(xs shr rot or xs shl (-rot and 31))
  gen.state = gen.state * N + gen.inc

func nextFloat(gen: var PCG32): float =
  gen.nextInt().float / float(0xFFFFFFFFu32)


when isMainModule:

  var gen: PCG32

  gen.seed(42, 54)
  for _ in 1..5:
    echo gen.nextInt()

  echo ""
  gen.seed(987654321, 1)
  var counts: CountTable[int]
  for _ in 1..100_000:
    counts.inc int(gen.nextFloat() * 5)
  echo sorted(toSeq(counts.pairs)).mapIt($it[0] & ": " & $it[1]).join(", ")
