proc expandBraces(str: string) =

  var
    escaped = false
    depth = 0
    bracePoints: seq[int]
    bracesToParse: seq[int]

  for idx, ch in str:
    case ch
    of '\\':
      escaped = not escaped
    of '{':
      inc depth
      if not escaped and depth == 1:
        bracePoints = @[idx]
    of ',':
      if not escaped and depth == 1:
        bracePoints &= idx
    of '}':
      if not escaped and depth == 1 and bracePoints.len >= 2:
        bracesToParse = bracePoints & idx
      dec depth
    else:
      discard
    if ch != '\\':
      escaped = false

  if bracesToParse.len > 0:
    let prefix = str[0..<bracesToParse[0]]
    let suffix = str[(bracesToParse[^1] + 1)..^1]
    for idx in 1..bracesToParse.high:
      let option = str[(bracesToParse[idx - 1] + 1)..(bracesToParse[idx] - 1)]
      expandBraces(prefix & option & suffix)

  else:
    echo "  ", str

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  for str in ["It{{em,alic}iz,erat}e{d,}, please.",
              "~/{Downloads,Pictures}/*.{jpg,gif,png}",
              "{,{,gotta have{ ,\\, again\\, }}more }cowbell!",
              "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"]:
    echo "\nExpansions of \"", str, "\":"
    expandBraces(str)
