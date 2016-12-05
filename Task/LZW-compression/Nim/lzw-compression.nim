import tables

proc compress*(uncompressed: string): seq[int] =
  ## build the dictionary
  var dictionary = initTable[string, int]()
  for i in 0..255:
    dictionary.add($char(i), i)

  var w: string = newString(0)
  var compressed = newSeq[int]()

  for c in uncompressed:
    var wc = w & c
    if(dictionary.hasKey(wc)):
      w = wc
    else:
      # writes w to output
      compressed.add(dictionary[w])
      # wc is a new sequence; add it to the dictionary
      dictionary.add(wc, dictionary.len)
      w = $c

  # write remaining output if necessary
  if(w != nil):
    compressed.add(dictionary[w])

  result = compressed

proc decompress*(compressed: var seq[int]): string =
  # build the dictionary
  var dictionary = initTable[int, string]()
  for i in 0..255:
    dictionary.add(i, $char(i))

  var w: string = dictionary[compressed[0]]

  compressed.delete(0)

  var decompressed = w

  for k in compressed:
    var entry: string = newString(0)
    if(dictionary.hasKey(k)):
      entry = dictionary[k]
    elif(k == dictionary.len):
      entry = w & w[0]
    else:
      raise newException(ValueError, "Bad compressed k: " & $k)

    decompressed &= entry

    # new sequence; add it to the dictionary
    dictionary.add(dictionary.len, w & entry[0])

    w = entry

  result = decompressed

when isMainModule:
  var compressed = compress("TOBEORNOTTOBEORTOBEORNOT")
  echo compressed
  var decompressed = decompress(compressed)
  echo decompressed
