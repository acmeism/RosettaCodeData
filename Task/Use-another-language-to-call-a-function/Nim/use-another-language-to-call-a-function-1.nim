proc Query*(data: var array[1024, char], length: var cint): cint {.exportc.} =
  const text = "Here am I"
  if length < text.len:
    return 0

  for i in 0 .. text.high:
    data[i] = text[i]
  length = text.len
  return 1
