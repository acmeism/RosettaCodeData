import algorithm, parsecsv, strformat, strutils, tables

const NoValue = -1.0

type

  Names = OrderedTable[Positive, string]      # Mapping id -> last name.

  Visit = tuple[date: string; score: float]
  Visits = Table[Positive, seq[Visit]]        # Mapping id -> list of visits.


proc readNames(path: string): Names =
  ## Read the records (id, lastname) from the CSV file and fill a Names table.
  var parser: CsvParser
  parser.open(path)
  parser.readHeaderRow()
  while parser.readRow():
    let id = parser.row[0].parseInt
    let name = parser.row[1]
    result[id] = name

proc readVisits(path: string): Visits =
  ## Read the records (id, date, score) from the CSV file and fill a Visits table.
  var parser: CsvParser
  parser.open(path)
  parser.readHeaderRow()
  while parser.readRow():
    let id = parser.row[0].parseInt
    let date = parser.row[1]
    let score = if parser.row[2].len == 0: NoValue else: parser.row[2].parseFloat
    result.mgetOrPut(id, @[]).add (date, score)


var
  names = readNames("patients1.csv")
  visits = readVisits("patients2.csv")

names.sort(system.cmp)

echo "| PATIENT_ID |  LASTNAME  | LAST_VISIT |  SCORE_SUM | SCORE_AVG |"
for (id, name) in names.pairs:
  let visitList = visits.getOrDefault(id).sorted()
  let lastVisit = if visitList.len == 0: "" else: visitList[^1].date
  var sum = 0.0
  var count = 0
  for visit in visitList:
    if visit.score != NoValue:
      sum += visit.score
      inc count
  let scoreSum = if count == 0: "" else: &"{sum:>4.1f}"
  let scoreAvg = if count == 0: "" else: &"{sum / count.toFloat: >4.2f}"
  echo &"| {id:^10} | {name:^10} | {lastVisit:^10} | {scoreSum:>7}    | {scoreAvg:>6}    |"
