  let rec count i acc =
    if i > int lmtb then acc else if buf.[i] then count (i + 1) (acc + 1) else count (i + 1) acc
  count 0 1
