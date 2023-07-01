declare
  A = {NewCell 42}
  OldVal
in
  {Show @A}         %% read a cell with @
  A := 43           %% change its value
  OldVal = A := 44  %% read and write at the same time (atomically)
