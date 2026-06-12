import strutils


func decide(pc: openArray[char]): bool =
  ## Terminate when first two characters of the
  ## permutation are 'B' and 'C' respectively.
  pc[0] == 'B' and pc[1] == 'C'


proc permute(values: openArray[char]; n: Positive) =

  let k = values.len
  var
    pn = newSeq[int](n)
    p = newSeq[char](n)

  while true:
    # Generate permutation
    for i, x in pn: p[i] = values[x]
    # Show progress.
    echo p.join(" ")
    # Pass to deciding function.
    if decide(p): return  # Terminate early.
    # Increment permutation number.
    var i = 0
    while true:
      inc pn[i]
      if pn[i] < k: break
      pn[i] = 0
      inc i
      if i == n: return  # All permutations generated.


permute("ABCD", 3)
