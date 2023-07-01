var a {.noInit.}: array[1_000_000, int]

# For a proc, {.noInit.} means that the result is not initialized.
proc p(): array[1000, int] {.noInit.} =
  for i in 0..999: result[i] = i
