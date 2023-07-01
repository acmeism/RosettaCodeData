import strutils, tables

const NumFields = 49
const DateField = 0
const FlagGoodValue = 1

var badRecords: int       # Number of records that have invalid formatted values.
var totalRecords: int     # Total number of records in the file.
var badInstruments: int   # Total number of records that have at least one instrument showing error.
var seenDates: Table[string, bool]  # Table to keep track of what dates we have seen.

proc checkFloats(floats: seq[string]): bool =
  ## Ensure we can parse all records as floats (except the date stamp).
  for index in 1..<NumFields:
    try:
      # We're assuming all instrument flags are floats not integers.
      discard parseFloat(floats[index])
    except ValueError:
      return false
  true

proc areAllFlagsOk(instruments: seq[string]): bool =
  ## Ensure that all sensor flags are ok.

  # Flags start at index 2, and occur every 2 fields.
  for index in countup(2, NumFields, 2):
    # We're assuming all instrument flags are floats not integers
    var flag = parseFloat(instruments[index])
    if flag < FlagGoodValue: return false
  true


# Note: we're not checking the format of the date stamp.

# Main.

var currentLine = 0
for line in "readings.txt".lines:
  currentLine.inc
  if line.len == 0: continue    # Empty lines don't count as records.

  var tokens = line.split({' ', '\t'})
  totalRecords.inc

  if tokens.len != NumFields:
    badRecords.inc
    continue

  if not checkFloats(tokens):
    badRecords.inc
    continue

  if not areAllFlagsOk(tokens):
    badInstruments.inc

  if seenDates.hasKeyOrPut(tokens[DateField], true):
    echo tokens[DateField], " duplicated on line ", currentLine

let goodRecords = totalRecords - badRecords
let goodInstruments = goodRecords - badInstruments

echo "Total Records: ", totalRecords
echo "Records with wrong format: ", badRecords
echo "Records where all instruments were OK: ", goodInstruments
