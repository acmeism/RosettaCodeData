import times
from algorithm import reversed
from strutils import addSep

const Units = [" wk", " d", " hr", " min", " sec"]

#---------------------------------------------------------------------------------------------------

proc `$$`*(sec: int): string =
  ## Convert a duration in seconds to a friendly string.
  ## Similar to `$` but with other conventions.

  doAssert(sec > 0)

  var duration = initDuration(seconds = sec)
  let parts = reversed(duration.toParts[Seconds..Weeks])

  for idx, part in parts:
    if part != 0:
      result.addSep(", ", 0)
      result.add($part & Units[idx])

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  for sec in [7259, 86400, 6000000]:
    echo sec, "s = ", $$sec
