import tables

proc compress*(uncompressed: string): seq[int] =

  # Build the dictionary.
  var dictionary: Table[string, int]
  for i in 0..255: dictionary[$chr(i)] = i

  var w = ""
  for c in uncompressed:
    var wc = w & c
    if wc in dictionary:
      w = wc
    else:
      # Writes "w" to output.
      result.add dictionary[w]
      # "wc" is a new sequence: add it to the dictionary.
      dictionary[wc] = dictionary.len
      w = $c

  # Write remaining output if necessary.
  if w.len > 0: result.add dictionary[w]


proc decompress*(compressed: var seq[int]): string =

  # Build the dictionary.
  var dictionary: Table[int, string]
  for i in 0..255: dictionary[i] = $chr(i)

  var w = dictionary[compressed[0]]
  compressed.delete(0)

  result = w
  for k in compressed:
    var entry: string
    if k in dictionary:
      entry = dictionary[k]
    elif k == dictionary.len:
      entry = w & w[0]
    else:
      raise newException(ValueError, "Bad compressed k: " & $k)
    result.add entry
    # New sequence: add it to the dictionary.
    dictionary[dictionary.len] = w & entry[0]
    w = entry


when isMainModule:
  var compressed = compress("TOBEORNOTTOBEORTOBEORNOT")
  echo compressed
  var decompressed = decompress(compressed)
  echo decompressed
