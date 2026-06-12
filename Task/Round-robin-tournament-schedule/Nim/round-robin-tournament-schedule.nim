import std/[algorithm, sequtils, strformat]

proc roundRobin(n: Positive) =
  assert n >= 2
  var n = n
  var list1 = toSeq(2..n)
  if n mod 2 == 1:
    list1.add 0  # 0 denotes a "bye".
    inc n
  for r in 1..<n:
    stdout.write &"Round {r:2}:"
    let list2 = 1 & list1
    for i in 0..<(n div 2):
      stdout.write &" ({list2[i]:>2} vs {list2[n - i - 1]:<2})"
    echo()
    list1.rotateLeft(-1)

echo "Round robin for 12 players:\n"
roundRobin(12)
echo "\n\nRound robin for 5 players (0 denotes a bye) :\n"
roundRobin(5)
