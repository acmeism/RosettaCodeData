import random, strformat, strutils, sugar

type ValRange = range[0.0..1.0]

func modifier(x: ValRange): ValRange =
  if x < 0.5: 2 * (0.5 - x) else: 2 * (x - 0.5)

proc rand(modifier: (float) -> float): ValRange =
  while true:
    let r1 = rand(1.0)
    let r2 = rand(1.0)
    if r2 < modifier(r1):
      return r1

const
  N = 100_000
  NumBins = 20
  HistChar = "■"
  HistCharSize = 125
  BinSize = 1 / NumBins

randomize()

var bins: array[NumBins, int]
for i in 0..<N:
  let rn = rand(modifier)
  let bn = int(rn / BinSize)
  inc bins[bn]

echo &"Modified random distribution with {N} samples in range [0, 1):"
echo "    Range           Number of samples within that range"
for i in 0..<NumBins:
  let hist = repeat(HistChar, (bins[i] / HistCharSize).toInt)
  echo &"{BinSize * float(i):4.2f} ..< {BinSize * float(i + 1):4.2f}  {hist} {bins[i]}"
