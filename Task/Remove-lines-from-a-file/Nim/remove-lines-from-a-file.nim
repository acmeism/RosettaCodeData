import sequtils, strutils

proc removeLines*(filename: string; start, count: Positive) =

  # Read the whole file, split into lines but keep the ends of line.
  var lines = filename.readFile().splitLines(keepEol = true)

  # Remove final empty string if any.
  if lines[^1].len == 0: lines.setLen(lines.len - 1)

  # Compute indices and check validity.
  let first = start - 1
  let last = first + count - 1
  if last >= lines.len:
    raise newException(IOError, "trying to delete lines after end of file.")

  # Delete the lines and write the file.
  lines.delete(first, last)
  filename.writeFile(lines.join())
