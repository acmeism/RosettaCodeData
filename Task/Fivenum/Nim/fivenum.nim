import algorithm

type FiveNum = array[5, float]

template isOdd(n: SomeInteger): bool = (n and 1) != 0

func median(x: openArray[float]; startIndex, endIndex: Natural): float =
  let size = endIndex - startIndex + 1
  assert(size > 0, "array slice cannot be empty")
  let m = startIndex + size div 2
  result = if size.isOdd: x[m] else: (x[m-1] + x[m]) / 2

func fivenum(x: openArray[float]): FiveNum =
  let x = sorted(x)
  let m = x.len div 2
  let lowerEnd = if x.len.isOdd: m else: m - 1
  result[0] = x[0]
  result[1] = median(x, 0, lowerEnd)
  result[2] = median(x, 0, x.high)
  result[3] = median(x, m, x.high)
  result[4] = x[^1]

const Lists = [@[15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0],
               @[36.0, 40.0, 7.0, 39.0, 41.0, 15.0],
               @[0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
                 0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
                 0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
                 0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578]]

for list in Lists:
  echo ""
  echo list
  echo "  →  ", list.fivenum
