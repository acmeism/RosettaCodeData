proc first(fn: proc): auto =
  return fn()

proc second(): string =
  return "second"

echo first(second)
