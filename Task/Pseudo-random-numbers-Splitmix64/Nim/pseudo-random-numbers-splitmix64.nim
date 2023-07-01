import math, sequtils, strutils

const Two64 = 2.0^64

type Splitmix64 = object
  state: uint64

func initSplitmix64(seed: uint64): Splitmix64 =
  ## Initialize a Splitmiax64 PRNG.
  Splitmix64(state: seed)

func nextInt(r: var Splitmix64): uint64 =
  ## Return the next pseudorandom integer (actually a uint64 value).
  r.state += 0x9e3779b97f4a7c15u
  var z = r.state
  z = (z xor z shr 30) * 0xbf58476d1ce4e5b9u
  z = (z xor z shr 27) * 0x94d049bb133111ebu
  result = z xor z shr 31

func nextFloat(r: var Splitmix64): float =
  ## Retunr the next pseudorandom float (between 0.0 and 1.0 excluded).
  r.nextInt().float / Two64


when isMainModule:

  echo "Seed = 1234567:"
  var prng = initSplitmix64(1234567)
  for i in 1..5:
    echo i, ": ", ($prng.nextInt).align(20)

  echo "\nSeed = 987654321:"
  var counts: array[0..4, int]
  prng = initSplitmix64(987654321)
  for _ in 1..100_000:
    inc counts[int(prng.nextFloat * 5)]
  echo toSeq(counts.pairs).mapIt(($it[0]) & ": " & ($it[1])).join(", "
