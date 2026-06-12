import std/[strformat, strutils]

proc numDecPlaces(strval: string): Natural =
  let parts = strval.split('.')
  if parts.len == 1: return 0
  if parts.len > 2:
    raise newException(ValueError, "not the decimal representation of a number.")
  result = parts[1].len

for strval in ["1", "1.5", "12.345", "12.3450"]:
  let n = numDecPlaces(strval)
  echo &"“{strval}” has {n} decimal{(if n > 1: \"s\" else: \"\")}."
