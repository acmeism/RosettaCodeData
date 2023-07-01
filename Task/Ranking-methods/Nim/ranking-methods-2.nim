import algorithm

type
  Record = tuple[score: int; name: string]                  # Input data.
  Rank = tuple[rank: int; name: string; score: int]         # Result.
  FractRank = tuple[rank: float; name: string; score: int]  # Result (fractional).

func cmp(a, b: Record): int =
  ## Record comparison function (needed for sorting).
  result = cmp(b[0], a[0])        # Reverse order.
  if result == 0:
    result = cmp(a.name, b.name)  # Alphabetical order.

func standardRanks(records: openArray[Record]): seq[Rank] =
  let records = sorted(records, cmp)
  var rank = 1
  var currScore = records[0].score
  for idx, (score, name) in records:
    if score != currScore:
      rank = idx + 1
      currScore = score
    result.add (rank, name, score)

func modifiedRanks(records: openArray[Record]): seq[Rank] =
  let records = sorted(records, cmp)
  var rank = records.len
  var currScore = records[^1].score
  for idx in countdown(records.high, 0):
    let (score, name) = records[idx]
    if score != currScore:
      rank = idx + 1
      currScore = score
    result.add (rank, name, score)
  result.reverse()

func denseRanks(records: openArray[Record]): seq[Rank] =
  let records = sorted(records, cmp)
  var rank = 1
  var currScore = records[0].score
  for (score, name) in records:
    if score != currScore:
      inc rank
      currScore = score
    result.add (rank, name, score)

func ordinalRanks(records: openArray[Record]): seq[Rank] =
  let records = sorted(records, cmp)
  var rank = 0
  for (score, name) in records:
    inc rank
    result.add (rank, name, score)

func fractionalRanks(records: openArray[Record]): seq[FractRank] =
  let records = sorted(records, cmp)

  # Build a list of ranks.
  var currScore = records[0].score
  var sum = 0
  var ranks: seq[float]
  var count = 0
  for idx, record in records:
    if record.score == currScore:
      inc count
      inc sum, idx + 1
    else:
      ranks.add sum / count
      count = 1
      currScore = record.score
      sum = idx + 1
  ranks.add sum / count

  # Give a rank to each record.
  currScore = records[0].score
  var rankIndex = 0
  for (score, name) in records:
    if score != currScore:
      inc rankIndex
      currScore = score
    result.add (ranks[rankIndex], name, score)

when isMainModule:

  const Data = [(44, "Solomon"), (42, "Jason"), (42, "Errol"),
                (41, "Garry"), (41, "Bernard"), (41, "Barry"), (39, "Stephen")]

  echo "Standard ranking:"
  for (rank, name, score) in Data.standardRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Modified ranking:"
  for (rank, name, score) in Data.modifiedRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Dense ranking:"
  for (rank, name, score) in Data.denseRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Ordinal ranking:"
  for (rank, name, score) in Data.ordinalRanks():
    echo rank, ": ", name, " ", score

  echo()
  echo "Fractional ranking:"
  for (rank, name, score) in Data.fractionalRanks():
    echo rank, ": ", name, " ", score
