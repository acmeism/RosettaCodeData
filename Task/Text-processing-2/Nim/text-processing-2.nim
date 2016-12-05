import strutils, tables

const NumFields = 49
const DateField = 0
const FlagGoodValue = 1

var badRecords: int # the number of records that have invalid formatted values
var totalRecords: int # the total number of records in the file
var badInstruments: int   # the total number of records that have at least one instrument showing error
var seenDates = newTable[string,bool]() # table that keeps track of what dates we have seen

# ensure we can parse all records as floats (except the date stamp)
proc checkFloats(floats:seq[string]): bool =
  for index in 1..NumFields-1:
    try:
      # we're assuming all instrument flags are floats not integers
      discard parseFloat(floats[index])
    except ValueError:
      return false
  true

# ensure that all sensor flags are ok
proc areAllFlagsOk(instruments: seq[string]): bool =
  #flags start at index 2, and occur every 2 fields
  for index in countup(2,NumFields,2):
    # we're assuming all instrument flags are floats not integers
    var flag = parseFloat(instruments[index])
    if flag < FlagGoodValue: return false
  true


# Note: we're not checking the format of the date stamp

# main
var lines = readFile("readings.txt")
var currentLine: int

for line in lines.splitLines:
  currentLine.inc
  #empty lines don't count as records
  if line.len == 0: continue

  var tokens = line.split({' ','\t'})

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

var goodRecords = totalRecords - badRecords
var goodInstruments = goodRecords - badInstruments

echo "Total Records:", totalRecords
echo "Good Records:", goodRecords
echo "Records where all instuments were OK:", goodInstruments
