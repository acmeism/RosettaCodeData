import std/[bitops, math, sequtils, strutils]

type

  # Lengths of distinct runs of occupied cells.
  Lengths = seq[int]

  # Possibility, i.e. sequence of bits managed as an integer.
  Possibility = int

  # Possibilities described by two masks and a list of integer values.
  Possibilities = object
    mask0: int        # Mask indicating the positions of free cells.
    mask1: int        # Mask indicating the positions of occupied cells.
    list: seq[int]    # List of possibilities.


proc genSequence(ones: seq[int]; numZeroes: Natural): seq[Possibility] =
  ## Generate a sequence of possibilities.
  if ones.len == 0: return @[0]
  for x in 1..(numZeroes - ones.len + 1):
    for tail in genSequence(ones[1..^1], numZeroes - x):
      result.add (tail shl countSetBits(ones[0]) or ones[0]) shl x


proc initPossibilities(lengthsList: openArray[Lengths]; length: Positive): seq[Possibilities] =
  ## Initialize the list of possibilities from a list of lengths.

  let initMask0 = 1 shl length - 1
  for lengths in lengthsList:
    let sumLengths = sum(lengths)
    let prep = lengths.mapIt(1 shl it - 1)
    let possList = genSequence(prep, length - sumLengths + 1).mapIt(it shr 1)
    result.add Possibilities(mask0: initMask0, mask1: 0, list: possList)


func updateUnset(possList: var seq[Possibilities]; mask, rank: int) =
  ## Update the lists of possibilities keeping only those
  ## compatible with the mask (for bits not set only).
  var mask = mask
  for poss in possList.mitems:
    if (mask and 1) == 0:
      for i in countdown(poss.list.high, 0):
        if poss.list[i].testBit(rank):
          # Bit is set, so the value is not compatible: remove it.
          poss.list.delete(i)
    mask = mask shr 1


func updateSet(possList: var seq[Possibilities]; mask, rank: int) =
  ## Update the lists of possibilities keeping only those
  ## compatible with the mask (for bits set only).
  var mask = mask
  for poss in possList.mitems:
    if (mask and 1) != 0:
      for i in countdown(poss.list.high, 0):
        if not poss.list[i].testBit(rank):
          # Bit is not set, so the value is not compatible: remove it.
          poss.list.delete(i)
    mask = mask shr 1


proc process(poss1, poss2: var seq[Possibilities]): bool =
  ## Look at possibilities in list "poss1", compute the masks for
  ## bits unset and bits set and update "poss2" accordingly.

  var num = 0
  for poss in poss1.mitems:

    # Check bits unset.
    var mask = 0
    for value in poss.list:
      mask = mask or value
    if mask != poss.mask0:
      # Mask has changed: update.
      result = true
      poss2.updateUnset(mask, num)
      poss.mask0 = mask

    # Check bits set.
    mask = 1 shl poss2.len - 1
    for value in poss.list:
      mask = mask and value
    if mask != poss.mask1:
      # Mask has changed: update.
      result = true
      poss2.updateSet(mask, num)
      poss.mask1 = mask

    inc num


proc solve(rowLengths, colLengths: openArray[Lengths]) =
  ## Solve nonogram defined by "rowLengths" and "colLengths".

  var
    rowPoss = initPossibilities(rowLengths, colLengths.len)
    colPoss = initPossibilities(colLengths, rowLengths.len)

    # Solve nonogram.
  var hasChanged = true
  while hasChanged:
    hasChanged = process(rowPoss, colPoss) or process(colPoss, rowPoss)

  # Check if solved.
  for poss in rowPoss:
    if poss.list.len != 1:
      echo "Unable to solve the nonogram."
      return

  # Display the solution.
  for poss in rowPoss:
    var line = ""
    var val = poss.list[0]
    for i in 0..colPoss.high:
      line.add if val.testBit(i): "# " else: "  "
    echo line


func expand(s: string): seq[Lengths] =
  ## Expand a compact description into a sequence of lengths.
  for elem in s.splitWhitespace():
    result.add elem.mapIt(ord(it) - ord('A') + 1)


proc solve(rows, cols: string) =
  ## Solve using compact description parameters.
  solve(rows.expand(), cols.expand())


when isMainModule:

  const

    Data1 = ("C BA CB BB F AE F A B", "AB CA AE GA E C D C")

    Data2 = ("F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
             "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA")

    Data3 = ("CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
             "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF AAAAD BDG CEF CBDB BBB FC")

    Data4 = ("E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
             "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM")

  for (rows, cols) in [Data1, Data2, Data3, Data4]:
    echo rows
    echo cols
    echo ""
    solve(rows, cols)
    echo ""
