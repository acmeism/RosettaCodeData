import std/[algorithm, strutils]

var ends = @["1", "5", "6"]
var steady = @[1, 5, 6]
while ends.len != 0:
  var newEnds: seq[string]
  for e in ends:
    for d in '1'..'9':
      let s = d & e
      let n = parseInt(s)
      if n >= 10_000: break
      if ($(n * n)).endsWith(s):
        steady.add n
        newEnds.add s
  ends = newEnds

echo "Steady squares under 10_000: "
for n in sorted(steady):
  echo n, "² = ", n * n
