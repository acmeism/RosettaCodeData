{.push overflowChecks: on.}
proc divCheck(x, y): bool =
  try:
    discard x div y
  except DivByZeroDefect:
    return true
  return false
{.pop.} # Restore default check settings

echo divCheck(2, 0)
