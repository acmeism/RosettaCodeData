import bitops, math, sequtils, strutils

const
  N = 30
  popcounts = toSeq(0..<N).mapIt(popcount(3^it))
  mapping = toSeq(0..<(2 * N)).mapIt((it, it.popcount))
  evil = mapping.filterIt((it[1] and 1) == 0).mapIt(it[0])
  odious = mapping.filterIt((it[1] and 1) != 0).mapIt(it[0])

echo "3^n:   ", popcounts.mapIt(($it).align(2)).join(" ")
echo "evil:  ", evil.mapIt(($it).align(2)).join(" ")
echo "odious:", odious.mapIt(($it).align(2)).join(" ")
