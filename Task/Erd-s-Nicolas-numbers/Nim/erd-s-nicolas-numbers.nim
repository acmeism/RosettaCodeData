import std/[sequtils, strformat]

proc main() =
  const MaxNumber = 100_000_000i32
  var dsum, dcount = repeat(1'i32, MaxNumber + 1)
  for i in 2i32..MaxNumber:
    for j in countup(i + i, MaxNumber, i):
      if dsum[j] == j:
        echo &"{j:>8} equals the sum of its first {dcount[j]} divisors"
      inc dsum[j], i
      inc dcount[j]
main()
