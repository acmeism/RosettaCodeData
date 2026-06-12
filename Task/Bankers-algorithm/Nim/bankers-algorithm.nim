import sequtils, strformat, strutils, sugar

stdout.write "Enter the number of resources: "
let r = stdin.readLine().parseInt()

stdout.write "Enter the number of processes: "
stdout.flushFile()
let p = stdin.readLine().parseInt()

stdout.write "Enter Claim Vector: "
let maxRes = stdin.readLine().splitWhitespace().map(parseInt)

echo "Enter Allocated Resource Table:"
var curr = newSeqWith(p, newSeq[int](r))
for i in 0..<p:
  stdout.write &"Row {i + 1}: "
  curr[i] = stdin.readLine().splitWhitespace().map(parseInt)

echo "Enter Maximum Claim Table:"
var maxClaim = newSeqWith(p, newSeq[int](r))
for i in 0..<p:
  stdout.write &"Row {i + 1}:  "
  maxClaim[i] = stdin.readLine().splitWhitespace().map(parseInt)

var alloc = newSeq[int](r)
for i in 0..<p:
  for j in 0..<r:
    alloc[j] += curr[i][j]
echo &"\nAllocated Resources: {alloc.join(\" \")}"

var avl = collect(newSeq, for i in 0..<r: maxRes[i] - alloc[i])
echo &"Available Resources: {avl.join(\" \")}"

var running = repeat(true, p)
var count = p
while count > 0:
  var safe = false
  for i in 0..<p:
    if running[i]:
      var exec = true
      for j in 0..<r:
        if maxClaim[i][j] - curr[i][j] > avl[j]:
          exec = false
          break
      if exec:
        echo &"\nProcess {i + 1} is executing."
        running[i] = false
        dec count
        safe = true
        for j in 0..<r: avl[j] += curr[i][j]
        break

  if not safe:
    echo "The processes are in an unsafe state."
    break

  echo "\nThe process is in a safe state."
  echo &"Available Vector: {avl.join(\" \")}"
