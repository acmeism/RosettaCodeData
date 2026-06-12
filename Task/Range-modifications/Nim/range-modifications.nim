import algorithm, sequtils, strscans, strutils

type
  Range = tuple[low, high: int]
  Ranges = seq[Range]


func `$`(ranges: Ranges): string =
  ## Return the string representation of a list of ranges.
  result.add '"'
  for r in ranges:
    result.addSep(",", 1)
    result.add "$1-$2".format(r.low, r.high)
  result.add '"'


proc initRanges(ranges: varargs[Range]): seq[Range] =
  ## Create a list of ranges with the given (potentially empty) ranges.
  stdout.write "Start with    "
  var ranges = ranges.filterIt(it.low <= it.high)
  if ranges.len <= 1:
    echo ranges
    return ranges
  ranges.sort()
  result = @[ranges[0]]
  for newRange in ranges[1..^1]:
    if newRange.low <= result[^1].high:
      # Intersection is not empty.
      if newRange.high > result[^1].low: result[^1].high = newRange.high
    else:
      # New range.
      result.add newRange
  echo result


proc initRanges(rangeString: string): seq[Range] =
  ## Create a list fo ranges from a string representation.
  if rangeString.len == 0: return
  var ranges: seq[Range]
  for field in rangeString.split(','):
    var r: Range
    if field.scanf("$i-$i$.", r.low, r.high):
      ranges.add r
    else:
      raise newException(ValueError, "Wrong range specification: " & field)
  result = initRanges(ranges)


func contains(r: Range; val: int): bool =
  ## Return true if a range contains a value.
  ## Used by "in" operator.
  val >= r.low and val <= r.high


proc add(ranges: var Ranges; val: int) =
  ## Add a value to a list of ranges.
  stdout.write "add ", ($val).alignLeft(2), "     →  "
  if ranges.len == 0:
    ranges.add (val, val)
    echo ranges
    return
  # Search the range immediately following the value.
  var idx = -1
  for i, r in ranges:
    if val in r:
      # Already in a range: no changes.
      echo ranges
      return
    if val < r.low:
      idx = i
      break
  if idx < 0:
    # Not found, so to add at the end.
    if ranges[^1].high == val - 1: ranges[^1].high = val  # Extend last range.
    else: ranges.add (val, val)                           # Add a range.
  elif ranges[idx].low == val + 1:
    # Just before a range.
    ranges[idx].low = val
    if idx > 0:
      if ranges[idx-1].high >= val - 1:
        # Merge two ranges.
        ranges[idx].low = ranges[idx-1].low
        ranges.delete(idx - 1)
  elif idx > 0:
    # Between two ranges.
    if ranges[idx-1].high == val - 1: ranges[idx-1].high = val  # Extend previous range.
    else: ranges.insert((val, val), idx)                        # Insert a range.
  else:
    # At the beginning.
    ranges.insert((val, val), 0)
  echo ranges


proc remove(ranges: var Ranges; val: int) =
  ## remove a value from a list of ranges.
  stdout.write "remove ", ($val).alignLeft(2), "  →  "
  # Search the range containing the value.
  var idx = - 1
  for i, r in ranges:
    if val in r:
      idx = i
      break
    if val < r.low: break
  if idx < 0:
    # Not found.
    echo ranges
    return
  let r = ranges[idx]
  if r.low == val:
    if r.high == val:
      # Delete the range.
      ranges.delete(idx)
    else:
      # Update the low value.
      ranges[idx].low = val + 1
  elif r.high == val:
    # Update the high value.
    ranges[idx].high = val - 1
  else:
    # Split the range.
    ranges.insert(r, idx + 1)
    ranges[idx].high = val - 1
    ranges[idx+1].low = val + 1
  echo ranges


var r = initRanges("")
r.add 77
r.add 79
r.add 78
r.remove 77
r.remove 78
r.remove 79
echo()

r = initRanges("1-3,5-5")
r.add 1
r.remove 4
r.add 7
r.add 8
r.add 6
r.remove 7
echo()

r = initRanges("1-5,10-25,27-30")
r.add 26
r.add 9
r.add 7
r.remove 26
r.remove 9
r.remove 7
