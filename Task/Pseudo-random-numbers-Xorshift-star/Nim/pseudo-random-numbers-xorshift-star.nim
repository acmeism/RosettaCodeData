import algorithm, sequtils, strutils, tables

const C = 0x2545F4914F6CDD1Du64

type XorShift = object
  state: uint64

func seed(gen: var XorShift; num: uint64) =
  gen.state = num

func nextInt(gen: var XorShift): uint32 =
  var x = gen.state
  x = x xor x shr 12
  x = x xor x shl 25
  x = x xor x shr 27
  gen.state = x
  result = uint32((x * C) shr 32)

func nextFloat(gen: var XorShift): float =
  gen.nextInt().float / float(0xFFFFFFFFu32)


when isMainModule:

  var gen: XorShift

  gen.seed(1234567)

  for _ in 1..5:
    echo gen.nextInt()

  echo ""
  gen.seed(987654321)
  var counts: CountTable[int]
  for _ in 1..100_000:
    counts.inc int(gen.nextFloat() * 5)
  echo sorted(toSeq(counts.pairs)).mapIt($it[0] & ": " & $it[1]).join(", ")
