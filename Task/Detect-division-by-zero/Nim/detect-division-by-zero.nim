# In debug builds division by zero exceptions are thrown by default, in release
# builds not. We can still enable them explicitly.
{.push overflowChecks: on.}
proc divCheck(x, y): bool =
  try:
    discard x div y
  except DivByZeroError:
    return true
  return false
{.pop.} # Restore default check settings

echo divCheck(2, 0)
