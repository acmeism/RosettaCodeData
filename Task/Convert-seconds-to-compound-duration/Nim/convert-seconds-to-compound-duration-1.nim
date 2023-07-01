from strutils import addSep

const
  Units = [" wk", " d", " hr", " min", " sec"]
  Quantities = [7 * 24 * 60 * 60, 24 * 60 * 60, 60 * 60, 60, 1]

#---------------------------------------------------------------------------------------------------

proc `$$`*(sec: int): string =
  ## Convert a duration in seconds to a friendly string.

  doAssert(sec > 0)

  var duration = sec
  var idx = 0
  while duration != 0:
    let q = duration div Quantities[idx]
    if q != 0:
      duration = duration mod Quantities[idx]
      result.addSep(", ", 0)
      result.add($q & Units[idx])
    inc idx

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  for sec in [7259, 86400, 6000000]:
    echo sec, "s = ", $$sec
