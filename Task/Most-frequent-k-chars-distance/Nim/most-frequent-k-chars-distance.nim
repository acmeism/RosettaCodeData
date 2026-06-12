import algorithm, sugar, tables

type CharCounts = OrderedTable[char, int]

func `$`(counts: CharCounts): string =
  for (c, count) in counts.pairs:
    result.add $c & $count

func mostFreqKHashing(str: string; k: Positive): CharCounts =
  var counts: CharCounts                 # To get the counts in apparition order.
  for c in str: inc counts.mgetOrPut(c, 0)
  counts.sort((x, y) => cmp(x[1], y[1]), Descending)  # Note that sort is stable.
  var count = 0
  for c, val in counts.pairs:
    inc count
    result[c] = val
    if count == k: break

func mostFreqKSimilarity(input1, input2: CharCounts): int =
  for c, count in input1.pairs:
    if c in input2:
      result += count

func mostFreqKSDF(str1, str2: string; k, maxDistance: Positive): int =
  maxDistance - mostFreqKSimilarity(mostFreqKHashing(str1, k), mostFreqKHashing(str2, k))


const

  Pairs = [("night", "nacht"),
           ("my", "a"),
           ("research", "research"),
           ("aaaaabbbb", "ababababa"),
           ("significant", "capabilities")]

for (str1, str2) in Pairs:
  echo "str1: ", str1
  echo "str2: ", str2
  echo "mostFreqKHashing(str1, 2) = ", mostFreqKHashing(str1, 2)
  echo "mostFreqKHashing(str2, 2) = ", mostFreqKHashing(str2, 2)
  echo "mostFreqKSDF(str1, str2, 2, 10) = ", mostFreqKSDF(str1, str2, 2, 10)
  echo()

const
  S1 = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
  S2 = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"

echo "str1: ", S1
echo "str2: ", S2
echo "mostFreqKHashing(str1, 2) = ", mostFreqKHashing(S1, 2)
echo "mostFreqKHashing(str2, 2) = ", mostFreqKHashing(S2, 2)
echo "mostFreqKSDF(str1, str2, 2, 100) = ", mostFreqKSDF(S1, S2, 2, 100)
