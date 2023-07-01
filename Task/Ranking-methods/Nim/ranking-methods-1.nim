import algorithm, sequtils, stats, tables

type
  Record = tuple[score: int; name: string]                  # Input data.
  Groups = OrderedTable[int, seq[string]]                   # Maps score to list of names.
  Rank = tuple[rank: int; name: string; score: int]         # Result.
  FractRank = tuple[rank: float; name: string; score: int]  # Result (fractional).

func cmp(a, b: (int, seq[string])): int =
  ## Comparison function needed to sort the groups.
  cmp(a[0], b[0])

func toGroups(records: openArray[Record]): Groups =
  ## Build a "Groups" table from the records.
  for record in records:
    result.mgetOrPut(record.score, @[]).add record.name
  # Sort the list of names by alphabetic order.
  for score in result.keys:
    sort(result[score])
  # Sort the groups by decreasing score.
  result.sort(cmp, Descending)

func standardRanks(groups: Groups): seq[Rank] =
  var rank = 1
  for score, names in groups.pairs:
    for name in names:
      result.add (rank, name, score)
    inc rank, names.len

func modifiedRanks(groups: Groups): seq[Rank] =
  var rank = 0
  for score, names in groups.pairs:
    inc rank, names.len
    for name in names:
      result.add (rank, name, score)

func denseRanks(groups: Groups): seq[Rank] =
  var rank = 0
  for score, names in groups.pairs:
    inc rank
    for name in names:
      result.add (rank, name, score)

func ordinalRanks(groups: Groups): seq[Rank] =
  var rank = 0
  for score, names in groups.pairs:
    for name in names:
      inc rank
      result.add (rank, name, score)

func fractionalRanks(groups: Groups): seq[FractRank] =
  var rank = 1
  for score, names in groups.pairs:
    let fRank = mean(toSeq(rank..(rank + names.high)))
    for name in names:
      result.add (fRank, name, score)
    inc rank, names.len

when isMainModule:
  const Data = [(44, "Solomon"), (42, "Jason"), (42, "Errol"),
                (41, "Garry"), (41, "Bernard"), (41, "Barry"), (39, "Stephen")]

  let groups = Data.toGroups()
  echo "Standard ranking:"
  for (rank, name, score) in groups.standardRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Modified ranking:"
  for (rank, name, score) in groups.modifiedRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Dense ranking:"
  for (rank, name, score) in groups.denseRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Ordinal ranking:"
  for (rank, name, score) in groups.ordinalRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Fractional ranking:"
  for (rank, name, score) in groups.fractionalRanks():
    echo rank, ": ", name, " ", score
